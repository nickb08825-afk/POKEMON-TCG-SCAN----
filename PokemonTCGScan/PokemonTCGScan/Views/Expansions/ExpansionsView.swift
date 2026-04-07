import SwiftUI

struct ExpansionsView: View {
    private let catalog = MockCatalogService.shared

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Gradients.heroBackground.ignoresSafeArea()
                VStack(alignment: .leading, spacing: 0) {
                    headerSection
                    ScrollView {
                        LazyVStack(spacing: Theme.Spacing.sm) {
                            ForEach(catalog.expansions, id: \.self) { setName in
                                ExpansionRow(setName: setName)
                            }
                        }
                        .padding(Theme.Spacing.md)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
            Text("EXPANSIONS")
                .font(Theme.Font.largeTitle)
                .foregroundColor(Theme.Colors.textPrimary)
            Text("\(catalog.expansions.count) sets")
                .font(Theme.Font.caption)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Theme.Spacing.md)
        .padding(.top, Theme.Spacing.md)
        .padding(.bottom, Theme.Spacing.sm)
    }
}

// MARK: - ExpansionRow
struct ExpansionRow: View {
    let setName: String

    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            // Set logo placeholder
            ZStack {
                Circle()
                    .fill(Theme.Colors.primaryBlue.opacity(0.3))
                    .frame(width: 48, height: 48)
                Image(systemName: "seal.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Theme.Colors.accentCyan)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(setName)
                    .font(Theme.Font.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                Text("Tap to browse cards")
                    .font(Theme.Font.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .padding(Theme.Spacing.md)
        .background(Color.white.opacity(0.08))
        .cornerRadius(Theme.Radius.card)
    }
}
