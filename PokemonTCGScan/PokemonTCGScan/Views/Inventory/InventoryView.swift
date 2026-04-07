import SwiftUI

// MARK: - InventoryView
struct InventoryView: View {
    @EnvironmentObject var store: JSONInventoryStore
    @State private var searchText = ""
    @State private var selectedFinish: Finish? = nil
    @State private var showExportSheet = false
    @State private var exportURL: URL? = nil
    @State private var isGridLayout = true

    var filteredItems: [InventoryItem] {
        store.items.filter { item in
            let matchesSearch = searchText.isEmpty ||
                item.cardName.localizedCaseInsensitiveContains(searchText) ||
                item.setName.localizedCaseInsensitiveContains(searchText) ||
                item.cardNumber.localizedCaseInsensitiveContains(searchText)
            let matchesFinish = selectedFinish == nil || item.finish == selectedFinish
            return matchesSearch && matchesFinish
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Gradients.heroBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    headerSection
                    filterChips
                    if filteredItems.isEmpty {
                        emptyState
                    } else if isGridLayout {
                        inventoryGrid
                    } else {
                        inventoryList
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showExportSheet) {
            if let url = exportURL {
                ShareSheet(activityItems: [url])
            }
        }
    }

    // MARK: Header
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("INVENTORY")
                        .font(Theme.Font.largeTitle)
                        .foregroundColor(Theme.Colors.textPrimary)
                    Text("\(store.items.count) cards")
                        .font(Theme.Font.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
                Spacer()
                HStack(spacing: Theme.Spacing.sm) {
                    Button {
                        isGridLayout.toggle()
                    } label: {
                        Image(systemName: isGridLayout ? "list.bullet" : "square.grid.2x2")
                            .foregroundColor(Theme.Colors.accentCyan)
                            .font(.system(size: 20))
                    }
                    Button {
                        exportCSV()
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(Theme.Colors.accentCyan)
                            .font(.system(size: 20))
                    }
                }
            }
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.top, Theme.Spacing.md)

            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Theme.Colors.textSecondary)
                TextField("Search cards, sets…", text: $searchText)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .tint(Theme.Colors.accentCyan)
                if !searchText.isEmpty {
                    Button { searchText = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                }
            }
            .padding(Theme.Spacing.sm)
            .background(Color.white.opacity(0.1))
            .cornerRadius(Theme.Radius.chip)
            .padding(.horizontal, Theme.Spacing.md)
        }
        .padding(.bottom, Theme.Spacing.sm)
    }

    // MARK: Filter chips
    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Theme.Spacing.sm) {
                FilterChip(title: "All", isSelected: selectedFinish == nil) {
                    selectedFinish = nil
                }
                ForEach(Finish.allCases) { finish in
                    FilterChip(title: finish.displayName, isSelected: selectedFinish == finish) {
                        selectedFinish = selectedFinish == finish ? nil : finish
                    }
                }
            }
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.vertical, Theme.Spacing.xs)
        }
    }

    // MARK: Grid layout
    private let columns = [
        GridItem(.flexible(), spacing: Theme.Spacing.sm),
        GridItem(.flexible(), spacing: Theme.Spacing.sm)
    ]

    private var inventoryGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: Theme.Spacing.sm) {
                ForEach(filteredItems) { item in
                    NavigationLink(destination: InventoryDetailView(item: item)) {
                        InventoryCardCell(item: item)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(Theme.Spacing.md)
        }
    }

    // MARK: List layout
    private var inventoryList: some View {
        ScrollView {
            LazyVStack(spacing: Theme.Spacing.sm) {
                ForEach(filteredItems) { item in
                    NavigationLink(destination: InventoryDetailView(item: item)) {
                        InventoryItemRow(item: item)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(Theme.Spacing.md)
        }
    }

    // MARK: Empty state
    private var emptyState: some View {
        VStack(spacing: Theme.Spacing.md) {
            Spacer()
            Image(systemName: "rectangle.stack.badge.plus")
                .font(.system(size: 60))
                .foregroundColor(Theme.Colors.textSecondary)
            Text("No cards yet")
                .font(Theme.Font.headline)
                .foregroundColor(Theme.Colors.textSecondary)
            Text("Use the Scan tab to add cards to your inventory.")
                .font(Theme.Font.body)
                .foregroundColor(Theme.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Theme.Spacing.xl)
            Spacer()
        }
    }

    // MARK: Export
    private func exportCSV() {
        let csv = ExportService.generateCSV(from: filteredItems)
        if let url = ExportService.writeCSV(csv) {
            exportURL = url
            showExportSheet = true
        }
    }
}

// MARK: - FilterChip
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(Theme.Font.caption)
                .foregroundColor(isSelected ? Theme.Colors.navyDark : Theme.Colors.textPrimary)
                .padding(.horizontal, Theme.Spacing.sm)
                .padding(.vertical, Theme.Spacing.xs)
                .background(isSelected ? Theme.Colors.accentCyan : Color.white.opacity(0.15))
                .cornerRadius(Theme.Radius.chip)
        }
    }
}
