import SwiftUI

// MARK: - ScanResultsView
/// Shows all detected cards from a scan batch, with per-card finish editing.
struct ScanResultsView: View {
    @Environment(\.dismiss) private var dismiss
    let results: [ScanResultCard]
    let onConfirm: ([ScanResultCard]) -> Void

    @State private var editableResults: [ScanResultCard]

    init(results: [ScanResultCard], onConfirm: @escaping ([ScanResultCard]) -> Void) {
        self.results = results
        self.onConfirm = onConfirm
        _editableResults = State(initialValue: results)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Gradients.heroBackground.ignoresSafeArea()
                VStack(spacing: 0) {
                    headerSection
                    ScrollView {
                        LazyVStack(spacing: Theme.Spacing.sm) {
                            ForEach($editableResults) { $card in
                                ScanResultCardRow(card: $card)
                            }
                        }
                        .padding(Theme.Spacing.md)
                    }
                    confirmButton
                }
            }
            .navigationBarHidden(true)
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("SCAN RESULTS")
                        .font(Theme.Font.title)
                        .foregroundColor(Theme.Colors.textPrimary)
                    Text("\(results.count) cards detected — all will be added")
                        .font(Theme.Font.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
                Spacer()
                Button { dismiss() } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Theme.Colors.textSecondary)
                }
            }
        }
        .padding(Theme.Spacing.md)
    }

    private var confirmButton: some View {
        Button {
            onConfirm(editableResults)
        } label: {
            Text("Add All to Inventory")
                .font(Theme.Font.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Theme.Spacing.md)
                .background(LinearGradient(colors: [Theme.Colors.primaryBlue, Theme.Colors.accentCyan],
                                           startPoint: .leading, endPoint: .trailing))
                .cornerRadius(Theme.Radius.button)
        }
        .padding(Theme.Spacing.md)
    }
}

// MARK: - ScanResultCardRow
struct ScanResultCardRow: View {
    @Binding var card: ScanResultCard

    var body: some View {
        HStack(spacing: Theme.Spacing.sm) {
            // Crop placeholder
            ZStack {
                Theme.Gradients.cardShimmer
                Image(systemName: "photo")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.4))
            }
            .frame(width: 48, height: 68)
            .cornerRadius(Theme.Radius.chip)

            VStack(alignment: .leading, spacing: 4) {
                Text(card.mockCard.cardName)
                    .font(Theme.Font.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .lineLimit(1)
                Text("\(card.mockCard.setName) · \(card.mockCard.cardNumber)")
                    .font(Theme.Font.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
                Text(card.mockCard.rarity)
                    .font(Theme.Font.caption)
                    .foregroundColor(Theme.Colors.textSecondary)

                // Finish picker
                HStack(spacing: 4) {
                    ForEach(Finish.allCases) { finish in
                        FinishPill(
                            label: finish.displayName,
                            isSelected: card.finish == finish,
                            isLowConfidence: card.finishConfidence < 0.55 && card.finishSource == .auto
                        ) {
                            card.finish = finish
                            card.finishSource = .userConfirmed
                        }
                    }
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                if let price = card.mockCard.lastSoldPriceUSD {
                    Text("$\(String(format: "%.2f", price))")
                        .font(Theme.Font.price)
                        .foregroundColor(Theme.Colors.accentCyan)
                }
                // Confidence indicator
                confidenceBadge
            }
        }
        .padding(Theme.Spacing.sm)
        .background(Color.white.opacity(0.08))
        .cornerRadius(Theme.Radius.card)
        .overlay(
            card.finishConfidence < 0.55 && card.finishSource == .auto
                ? RoundedRectangle(cornerRadius: Theme.Radius.card)
                    .stroke(Theme.Colors.warningAmber.opacity(0.6), lineWidth: 1.5)
                : nil
        )
    }

    private var confidenceBadge: some View {
        let isLow = card.finishConfidence < 0.55 && card.finishSource == .auto
        return HStack(spacing: 3) {
            if isLow {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 9))
                    .foregroundColor(Theme.Colors.warningAmber)
                Text("Confirm finish")
                    .font(.system(size: 9))
                    .foregroundColor(Theme.Colors.warningAmber)
            } else if card.finishSource == .userConfirmed {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 9))
                    .foregroundColor(Theme.Colors.positiveGreen)
                Text("Confirmed")
                    .font(.system(size: 9))
                    .foregroundColor(Theme.Colors.positiveGreen)
            } else {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 9))
                    .foregroundColor(Theme.Colors.textSecondary)
                Text("\(Int(card.finishConfidence * 100))%")
                    .font(.system(size: 9))
                    .foregroundColor(Theme.Colors.textSecondary)
            }
        }
    }
}

// MARK: - FinishPill
struct FinishPill: View {
    let label: String
    let isSelected: Bool
    let isLowConfidence: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(isSelected ? Theme.Colors.navyDark : Theme.Colors.textPrimary)
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(isSelected
                    ? (isLowConfidence ? Theme.Colors.warningAmber : Theme.Colors.accentCyan)
                    : Color.white.opacity(0.12))
                .cornerRadius(4)
        }
    }
}
