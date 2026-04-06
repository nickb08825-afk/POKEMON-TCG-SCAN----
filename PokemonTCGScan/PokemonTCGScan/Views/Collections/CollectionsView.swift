import SwiftUI

struct CollectionsView: View {
    @State private var collections: [CollectionItem] = CollectionItem.samples
    @State private var showNewCollection = false
    @State private var newCollectionName = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Gradients.heroBackground.ignoresSafeArea()
                VStack(alignment: .leading, spacing: 0) {
                    headerSection
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())],
                                  spacing: Theme.Spacing.sm) {
                            // "New Collection" tile
                            Button {
                                showNewCollection = true
                            } label: {
                                NewCollectionTile()
                            }
                            .buttonStyle(PlainButtonStyle())

                            ForEach(collections) { col in
                                CollectionTile(collection: col)
                            }
                        }
                        .padding(Theme.Spacing.md)
                    }
                }
            }
            .navigationBarHidden(true)
            .alert("New Collection", isPresented: $showNewCollection) {
                TextField("Collection name", text: $newCollectionName)
                Button("Create") {
                    guard !newCollectionName.isEmpty else { return }
                    collections.append(CollectionItem(name: newCollectionName, cardCount: 0))
                    newCollectionName = ""
                }
                Button("Cancel", role: .cancel) { newCollectionName = "" }
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
            Text("COLLECTIONS")
                .font(Theme.Font.largeTitle)
                .foregroundColor(Theme.Colors.textPrimary)
            Text("Organise your cards into groups")
                .font(Theme.Font.caption)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Theme.Spacing.md)
        .padding(.top, Theme.Spacing.md)
        .padding(.bottom, Theme.Spacing.sm)
    }
}

// MARK: - CollectionItem
struct CollectionItem: Identifiable {
    var id: UUID = UUID()
    var name: String
    var cardCount: Int
    var iconName: String = "rectangle.stack.fill"
    var color: Color = Theme.Colors.primaryBlue

    static let samples: [CollectionItem] = [
        CollectionItem(name: "Base Set Hits",   cardCount: 12, iconName: "sparkles",      color: Theme.Colors.accentCyan),
        CollectionItem(name: "Japanese",        cardCount: 8,  iconName: "globe.asia.australia.fill", color: Color(hex: "#A78BFA")),
        CollectionItem(name: "Holos",           cardCount: 24, iconName: "sparkles",      color: Theme.Colors.positiveGreen),
        CollectionItem(name: "Graded PSA",      cardCount: 3,  iconName: "shield.fill",   color: Theme.Colors.warningAmber),
    ]
}

// MARK: - NewCollectionTile
struct NewCollectionTile: View {
    var body: some View {
        VStack(spacing: Theme.Spacing.sm) {
            ZStack {
                Circle()
                    .strokeBorder(
                        style: StrokeStyle(lineWidth: 2, dash: [6])
                    )
                    .foregroundColor(Theme.Colors.primaryBlue.opacity(0.5))
                    .frame(width: 60, height: 60)
                Image(systemName: "plus")
                    .font(.system(size: 28, weight: .light))
                    .foregroundColor(Theme.Colors.primaryBlue.opacity(0.7))
            }
            Text("New Collection")
                .font(Theme.Font.caption)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.Spacing.lg)
        .background(Color.white.opacity(0.05))
        .cornerRadius(Theme.Radius.card)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.card)
                .stroke(Theme.Colors.primaryBlue.opacity(0.3), style: StrokeStyle(lineWidth: 1.5, dash: [6]))
        )
    }
}

// MARK: - CollectionTile
struct CollectionTile: View {
    let collection: CollectionItem

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack {
                Image(systemName: collection.iconName)
                    .font(.system(size: 28))
                    .foregroundColor(collection.color)
                Spacer()
                Text("\(collection.cardCount)")
                    .font(Theme.Font.title)
                    .foregroundColor(Theme.Colors.textPrimary)
            }
            Text(collection.name)
                .font(Theme.Font.headline)
                .foregroundColor(Theme.Colors.textPrimary)
                .lineLimit(2)
            Text("cards")
                .font(Theme.Font.caption)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .padding(Theme.Spacing.md)
        .background(Color.white.opacity(0.08))
        .cornerRadius(Theme.Radius.card)
    }
}
