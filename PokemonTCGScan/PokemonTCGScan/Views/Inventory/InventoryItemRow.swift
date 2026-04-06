import SwiftUI

// MARK: - InventoryItemRow (list layout)
struct InventoryItemRow: View {
    let item: InventoryItem

    var body: some View {
        HStack(spacing: Theme.Spacing.sm) {
            // Card art placeholder
            cardPlaceholder
                .frame(width: 52, height: 72)
                .cornerRadius(Theme.Radius.chip)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.cardName)
                    .font(Theme.Font.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .lineLimit(1)
                Text("\(item.setName) · \(item.cardNumber)")
                    .font(Theme.Font.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .lineLimit(1)
                finishBadge
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                if let price = item.lastSoldPriceUSD {
                    Text("$\(String(format: "%.2f", price))")
                        .font(Theme.Font.price)
                        .foregroundColor(priceColor(price: price, tier: item.rarityTier))
                } else {
                    Text("—")
                        .font(Theme.Font.price)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
                Text(item.rarity)
                    .font(Theme.Font.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .lineLimit(1)
            }
        }
        .padding(Theme.Spacing.sm)
        .background(Color.white.opacity(0.08))
        .cornerRadius(Theme.Radius.card)
    }

    private var finishBadge: some View {
        Text(item.finish.displayName)
            .font(Theme.Font.caption)
            .foregroundColor(finishColor)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(finishColor.opacity(0.2))
            .cornerRadius(4)
    }

    private var finishColor: Color {
        switch item.finish {
        case .nonFoil:     return Theme.Colors.textSecondary
        case .holo:        return Theme.Colors.accentCyan
        case .reverseHolo: return Color(hex: "#A78BFA")
        }
    }

    private var cardPlaceholder: some View {
        ZStack {
            Theme.Gradients.cardShimmer
            VStack(spacing: 2) {
                Image(systemName: "photo")
                    .font(.system(size: 20))
                    .foregroundColor(.white.opacity(0.5))
            }
        }
    }

    private func priceColor(price: Double, tier: RarityTier) -> Color {
        if price >= tier.hitThreshold * 2 { return Theme.Colors.positiveGreen }
        if price >= tier.hitThreshold     { return Theme.Colors.accentCyan }
        return Theme.Colors.textPrimary
    }
}

// MARK: - InventoryCardCell (grid layout)
struct InventoryCardCell: View {
    let item: InventoryItem

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
            // Card art area
            ZStack(alignment: .topTrailing) {
                cardPlaceholder
                    .frame(maxWidth: .infinity)
                    .aspectRatio(2/3, contentMode: .fit)
                    .cornerRadius(Theme.Radius.chip)

                finishBadge
                    .padding(4)
            }

            Text(item.cardName)
                .font(Theme.Font.headline)
                .foregroundColor(Theme.Colors.textPrimary)
                .lineLimit(1)

            Text(item.setName)
                .font(Theme.Font.caption)
                .foregroundColor(Theme.Colors.textSecondary)
                .lineLimit(1)

            if let price = item.lastSoldPriceUSD {
                Text("$\(String(format: "%.2f", price))")
                    .font(Theme.Font.price)
                    .foregroundColor(priceColor(price: price, tier: item.rarityTier))
            } else {
                Text("—")
                    .font(Theme.Font.price)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
        }
        .padding(Theme.Spacing.sm)
        .background(Color.white.opacity(0.08))
        .cornerRadius(Theme.Radius.card)
    }

    private var finishBadge: some View {
        Text(item.finish.displayName)
            .font(.system(size: 9, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 5)
            .padding(.vertical, 2)
            .background(finishColor.opacity(0.85))
            .cornerRadius(4)
    }

    private var finishColor: Color {
        switch item.finish {
        case .nonFoil:     return Color.gray
        case .holo:        return Theme.Colors.accentCyan
        case .reverseHolo: return Color(hex: "#A78BFA")
        }
    }

    private var cardPlaceholder: some View {
        ZStack {
            Theme.Gradients.cardShimmer
            Image(systemName: "photo")
                .font(.system(size: 32))
                .foregroundColor(.white.opacity(0.4))
        }
    }

    private func priceColor(price: Double, tier: RarityTier) -> Color {
        if price >= tier.hitThreshold * 2 { return Theme.Colors.positiveGreen }
        if price >= tier.hitThreshold     { return Theme.Colors.accentCyan }
        return Theme.Colors.textPrimary
    }
}

// MARK: - InventoryDetailView
struct InventoryDetailView: View {
    @EnvironmentObject var store: JSONInventoryStore
    let item: InventoryItem

    var body: some View {
        ZStack {
            Theme.Gradients.heroBackground.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                    // Card art
                    ZStack {
                        Theme.Gradients.cardShimmer
                        Image(systemName: "photo")
                            .font(.system(size: 80))
                            .foregroundColor(.white.opacity(0.3))
                    }
                    .frame(maxWidth: .infinity)
                    .aspectRatio(2/3, contentMode: .fit)
                    .cornerRadius(Theme.Radius.card)
                    .padding(.horizontal, Theme.Spacing.md)

                    // Info rows
                    Group {
                        detailRow("Card Name", item.cardName)
                        detailRow("Set", item.setName)
                        detailRow("Card Number", item.cardNumber)
                        detailRow("Rarity", item.rarity)
                        detailRow("Finish", item.finish.displayName)
                        detailRow("Language", item.language)
                        detailRow("Graded", item.graded ? "Yes" : "No")
                        detailRow("Condition", item.graded ? "N/A" : item.condition.rawValue)
                        if let price = item.lastSoldPriceUSD {
                            detailRow("Last Sold", "$\(String(format: "%.2f", price))")
                        }
                        detailRow("Scan Date", item.scanDateFormatted)
                    }
                    .padding(.horizontal, Theme.Spacing.md)
                }
                .padding(.bottom, Theme.Spacing.xl)
            }
        }
        .navigationTitle(item.cardName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    private func detailRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(Theme.Font.caption)
                .foregroundColor(Theme.Colors.textSecondary)
            Spacer()
            Text(value)
                .font(Theme.Font.body)
                .foregroundColor(Theme.Colors.textPrimary)
        }
        .padding(.vertical, Theme.Spacing.xs)
        Divider().background(Color.white.opacity(0.1))
    }
}
