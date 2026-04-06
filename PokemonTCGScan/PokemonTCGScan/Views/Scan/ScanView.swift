import SwiftUI

// MARK: - ScanView
struct ScanView: View {
    @EnvironmentObject var store: JSONInventoryStore
    @State private var isScanning = false
    @State private var scanResults: [ScanResultCard] = []
    @State private var showResults = false
    @State private var showUndoBanner = false
    @State private var lastAddedIDs: Set<UUID> = []
    @State private var pendingConfirmationIndex: Int = 0
    @State private var showConfirmation = false

    /// Cards from latest scan that still need finish confirmation
    private var nextPendingCard: ScanResultCard? {
        let lowConf = scanResults.filter { $0.finishConfidence < 0.55 && $0.finishSource == .auto }
        return lowConf.first
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Gradients.scanViewport.ignoresSafeArea()

                VStack(spacing: 0) {
                    headerSection
                    cameraViewport
                    scanButton
                }

                // Undo banner
                if showUndoBanner {
                    VStack {
                        Spacer()
                        UndoBanner(count: lastAddedIDs.count) {
                            store.remove(ids: lastAddedIDs)
                            lastAddedIDs = []
                            withAnimation { showUndoBanner = false }
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 90)
                    }
                    .animation(.spring(), value: showUndoBanner)
                }
            }
            .navigationBarHidden(true)
            // Review sheet: shows all results with inline finish editing
            .sheet(isPresented: $showResults) {
                ScanResultsView(results: scanResults) { approvedResults in
                    scanResults = approvedResults
                    showResults = false
                    addToInventory(scanResults)
                }
            }
            // Low-confidence finish confirmation (triggered after review sheet or directly)
            .sheet(isPresented: $showConfirmation) {
                if let card = nextPendingCard {
                    FinishConfirmationView(card: card) { confirmedFinish in
                        if let idx = scanResults.firstIndex(where: { $0.id == card.id }) {
                            scanResults[idx].finish = confirmedFinish
                            scanResults[idx].finishSource = .userConfirmed
                        }
                        // If more low-conf cards remain, keep sheet open
                        if nextPendingCard != nil {
                            // dismiss + re-show via state change
                            showConfirmation = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                showConfirmation = nextPendingCard != nil
                                if !showConfirmation { addToInventory(scanResults) }
                            }
                        } else {
                            showConfirmation = false
                            addToInventory(scanResults)
                        }
                    }
                }
            }
        }
    }

    // MARK: Header
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
            Text("SCAN")
                .font(Theme.Font.largeTitle)
                .foregroundColor(Theme.Colors.textPrimary)
            Text("Point at one or more cards and tap Scan")
                .font(Theme.Font.caption)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Theme.Spacing.md)
        .padding(.top, Theme.Spacing.md)
        .padding(.bottom, Theme.Spacing.sm)
    }

    // MARK: Camera viewport
    private var cameraViewport: some View {
        ZStack {
            Rectangle()
                .fill(Color.black.opacity(0.8))
                .cornerRadius(Theme.Radius.card)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.card)
                        .stroke(Theme.Colors.primaryBlue.opacity(0.6), lineWidth: 2)
                )

            if isScanning {
                VStack(spacing: Theme.Spacing.md) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Theme.Colors.accentCyan))
                        .scaleEffect(1.5)
                    Text("Detecting cards…")
                        .font(Theme.Font.body)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
            } else {
                ZStack {
                    ScanCornerBrackets()
                    VStack(spacing: Theme.Spacing.sm) {
                        Image(systemName: "camera.viewfinder")
                            .font(.system(size: 60))
                            .foregroundColor(Theme.Colors.primaryBlue.opacity(0.5))
                        Text("Camera feed will appear here")
                            .font(Theme.Font.caption)
                            .foregroundColor(Theme.Colors.textSecondary)
                        Text("(CV pipeline not yet connected)")
                            .font(.system(size: 10))
                            .foregroundColor(Theme.Colors.textSecondary.opacity(0.6))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(4/3, contentMode: .fit)
        .padding(.horizontal, Theme.Spacing.md)
    }

    // MARK: Scan button
    private var scanButton: some View {
        VStack(spacing: Theme.Spacing.sm) {
            Button {
                simulateScan()
            } label: {
                HStack(spacing: Theme.Spacing.sm) {
                    Image(systemName: isScanning ? "hourglass" : "camera.fill")
                    Text(isScanning ? "Scanning…" : "Scan Cards")
                        .font(Theme.Font.headline)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Theme.Spacing.md)
                .background(
                    isScanning
                        ? Color.gray.opacity(0.4)
                        : LinearGradient(colors: [Theme.Colors.primaryBlue, Theme.Colors.accentCyan],
                                         startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(Theme.Radius.button)
            }
            .disabled(isScanning)
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.top, Theme.Spacing.md)

            Text("Simulated scan — tap to test multi-card detection")
                .font(Theme.Font.caption)
                .foregroundColor(Theme.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.bottom, Theme.Spacing.lg)
    }

    // MARK: Simulate scan
    private func simulateScan() {
        isScanning = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            let count = Int.random(in: 3...6)
            let mockCards = MockCatalogService.shared.randomCards(count: count)
            scanResults = mockCards.enumerated().map { index, mock in
                let (finish, confidence) = MockCatalogService.shared.simulateFinishDetection(for: mock)
                return ScanResultCard(
                    mockCard: mock,
                    finish: finish,
                    finishConfidence: confidence,
                    finishSource: .auto,
                    cropIndex: index
                )
            }
            isScanning = false

            let hasLowConf = scanResults.contains { $0.finishConfidence < 0.55 }
            if hasLowConf {
                // Show review sheet; user can confirm finishes inline or all at once
                showResults = true
            } else {
                // All high confidence: auto-add immediately
                addToInventory(scanResults)
            }
        }
    }

    // MARK: Add to inventory
    private func addToInventory(_ results: [ScanResultCard]) {
        let items = results.map { $0.toInventoryItem() }
        let ids = Set(items.map(\.id))
        store.add(items)
        lastAddedIDs = ids
        withAnimation { showUndoBanner = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation { showUndoBanner = false }
        }
    }
}

// MARK: - ScanResultCard (local view model)
struct ScanResultCard: Identifiable {
    let id: UUID = UUID()
    let mockCard: MockCard
    var finish: Finish
    var finishConfidence: Double
    var finishSource: FinishSource
    let cropIndex: Int

    func toInventoryItem() -> InventoryItem {
        InventoryItem(
            cardName: mockCard.cardName,
            setName: mockCard.setName,
            cardNumber: mockCard.cardNumber,
            rarity: mockCard.rarity,
            rarityTier: RarityTier.from(rarityString: mockCard.rarity),
            finish: finish,
            finishConfidence: finishConfidence,
            finishSource: finishSource,
            language: mockCard.language,
            graded: false,
            condition: .nearMint,
            yearManufactured: mockCard.yearManufactured,
            lastSoldPriceUSD: mockCard.lastSoldPriceUSD,
            lastSoldDate: Date(),
            lastSoldSource: "mock",
            priceUpdatedAt: Date(),
            scanDate: Date(),
            cropImagePath: "crops/crop_\(cropIndex).jpg",
            originalPhotoPath: "photos/scan_\(Date().timeIntervalSince1970).jpg"
        )
    }
}

// MARK: - ScanCornerBrackets
struct ScanCornerBrackets: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            let l: CGFloat = 28, t: CGFloat = 3
            let color = Theme.Colors.accentCyan
            Group {
                // Top-left
                Path { p in
                    p.move(to: CGPoint(x: 24, y: 24 + l))
                    p.addLine(to: CGPoint(x: 24, y: 24))
                    p.addLine(to: CGPoint(x: 24 + l, y: 24))
                }.stroke(color, lineWidth: t)
                // Top-right
                Path { p in
                    p.move(to: CGPoint(x: w - 24 - l, y: 24))
                    p.addLine(to: CGPoint(x: w - 24, y: 24))
                    p.addLine(to: CGPoint(x: w - 24, y: 24 + l))
                }.stroke(color, lineWidth: t)
                // Bottom-left
                Path { p in
                    p.move(to: CGPoint(x: 24, y: h - 24 - l))
                    p.addLine(to: CGPoint(x: 24, y: h - 24))
                    p.addLine(to: CGPoint(x: 24 + l, y: h - 24))
                }.stroke(color, lineWidth: t)
                // Bottom-right
                Path { p in
                    p.move(to: CGPoint(x: w - 24 - l, y: h - 24))
                    p.addLine(to: CGPoint(x: w - 24, y: h - 24))
                    p.addLine(to: CGPoint(x: w - 24, y: h - 24 - l))
                }.stroke(color, lineWidth: t)
            }
        }
    }
}

// MARK: - UndoBanner
struct UndoBanner: View {
    let count: Int
    let onUndo: () -> Void

    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Theme.Colors.positiveGreen)
            Text("Added \(count) card\(count == 1 ? "" : "s") to inventory")
                .font(Theme.Font.body)
                .foregroundColor(Theme.Colors.textPrimary)
            Spacer()
            Button("Undo", action: onUndo)
                .font(Theme.Font.body.bold())
                .foregroundColor(Theme.Colors.accentCyan)
        }
        .padding(.horizontal, Theme.Spacing.md)
        .padding(.vertical, Theme.Spacing.sm)
        .background(Theme.Colors.undoBanner)
        .cornerRadius(Theme.Radius.card)
        .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
        .padding(.horizontal, Theme.Spacing.md)
    }
}
