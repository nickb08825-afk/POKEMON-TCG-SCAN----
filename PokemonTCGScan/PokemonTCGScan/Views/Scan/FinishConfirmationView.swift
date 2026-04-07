import SwiftUI

// MARK: - FinishConfirmationView
/// Shown only when finish confidence is < 0.55 for a specific card.
struct FinishConfirmationView: View {
    @Environment(\.dismiss) private var dismiss
    let card: ScanResultCard
    let onSelect: (Finish) -> Void

    @State private var selected: Finish

    init(card: ScanResultCard, onSelect: @escaping (Finish) -> Void) {
        self.card = card
        self.onSelect = onSelect
        _selected = State(initialValue: card.finish)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Gradients.heroBackground.ignoresSafeArea()
                VStack(spacing: Theme.Spacing.lg) {
                    // Warning header
                    VStack(spacing: Theme.Spacing.sm) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(Theme.Colors.warningAmber)
                        Text("Confirm Finish")
                            .font(Theme.Font.title)
                            .foregroundColor(Theme.Colors.textPrimary)
                        Text("Low confidence on \(card.mockCard.cardName) — please select the correct finish.")
                            .font(Theme.Font.body)
                            .foregroundColor(Theme.Colors.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Theme.Spacing.lg)
                    }
                    .padding(.top, Theme.Spacing.xl)

                    // Card preview placeholder
                    ZStack {
                        Theme.Gradients.cardShimmer
                        Image(systemName: "photo")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.3))
                    }
                    .frame(width: 140, height: 196)
                    .cornerRadius(Theme.Radius.card)

                    // Finish buttons
                    VStack(spacing: Theme.Spacing.sm) {
                        ForEach(Finish.allCases) { finish in
                            FinishOptionButton(
                                finish: finish,
                                isSelected: selected == finish
                            ) {
                                selected = finish
                            }
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.md)

                    Spacer()

                    // Confirm button
                    Button {
                        onSelect(selected)
                        dismiss()
                    } label: {
                        Text("Confirm")
                            .font(Theme.Font.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, Theme.Spacing.md)
                            .background(LinearGradient(
                                colors: [Theme.Colors.primaryBlue, Theme.Colors.accentCyan],
                                startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(Theme.Radius.button)
                    }
                    .padding(.horizontal, Theme.Spacing.md)
                    .padding(.bottom, Theme.Spacing.lg)
                }
            }
            .navigationBarHidden(true)
        }
        .presentationDetents([.large])
    }
}

// MARK: - FinishOptionButton
struct FinishOptionButton: View {
    let finish: Finish
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.Spacing.md) {
                Image(systemName: iconName)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? Theme.Colors.navyDark : iconColor)
                    .frame(width: 36)
                VStack(alignment: .leading, spacing: 2) {
                    Text(finish.displayName)
                        .font(Theme.Font.headline)
                        .foregroundColor(isSelected ? Theme.Colors.navyDark : Theme.Colors.textPrimary)
                    Text(description)
                        .font(Theme.Font.caption)
                        .foregroundColor(isSelected ? Theme.Colors.navyDark.opacity(0.7) : Theme.Colors.textSecondary)
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Theme.Colors.navyDark)
                }
            }
            .padding(Theme.Spacing.md)
            .background(isSelected ? Theme.Colors.accentCyan : Color.white.opacity(0.08))
            .cornerRadius(Theme.Radius.card)
        }
    }

    private var iconName: String {
        switch finish {
        case .nonFoil:     return "square"
        case .holo:        return "sparkles"
        case .reverseHolo: return "sparkle"
        }
    }

    private var iconColor: Color {
        switch finish {
        case .nonFoil:     return Theme.Colors.textSecondary
        case .holo:        return Theme.Colors.accentCyan
        case .reverseHolo: return Color(hex: "#A78BFA")
        }
    }

    private var description: String {
        switch finish {
        case .nonFoil:     return "Standard card, no foil"
        case .holo:        return "Foil artwork in the card image"
        case .reverseHolo: return "Foil on background, not artwork"
        }
    }
}
