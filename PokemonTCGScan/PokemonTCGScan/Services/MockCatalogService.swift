import Foundation

// MARK: - MockCard (catalog entry)
struct MockCard {
    var cardID: String
    var cardName: String
    var setName: String
    var cardNumber: String
    var rarity: String
    var yearManufactured: String
    var language: String = "English"
    var lastSoldPriceUSD: Double?
}

// MARK: - MockCatalogService
/// Placeholder catalog + pricing layer.
/// Replace with live pokemontcg.io API calls and a real last-sold price feed.
struct MockCatalogService {

    static let shared = MockCatalogService()

    // MARK: Mock catalog
    private let catalog: [MockCard] = [
        MockCard(cardID: "base1-4",   cardName: "Charizard",     setName: "Base Set",     cardNumber: "4/102",    rarity: "Rare Holo",               yearManufactured: "1999", lastSoldPriceUSD: 350.00),
        MockCard(cardID: "base1-6",   cardName: "Gyarados",      setName: "Base Set",     cardNumber: "6/102",    rarity: "Rare Holo",               yearManufactured: "1999", lastSoldPriceUSD: 65.00),
        MockCard(cardID: "swsh9-184", cardName: "Umbreon VMAX",  setName: "Brilliant Stars", cardNumber: "184/172", rarity: "Secret Rare",           yearManufactured: "2022", lastSoldPriceUSD: 120.00),
        MockCard(cardID: "sv3-198",   cardName: "Gardevoir ex",  setName: "Obsidian Flames", cardNumber: "198/197", rarity: "Special Illustration Rare", yearManufactured: "2023", lastSoldPriceUSD: 95.00),
        MockCard(cardID: "sv4-232",   cardName: "Charizard ex",  setName: "Paradox Rift", cardNumber: "232/182",  rarity: "Special Illustration Rare", yearManufactured: "2023", lastSoldPriceUSD: 180.00),
        MockCard(cardID: "xy1-45",    cardName: "Pikachu",       setName: "XY Base",      cardNumber: "45/146",   rarity: "Common",                  yearManufactured: "2014", lastSoldPriceUSD: 0.50),
        MockCard(cardID: "sm1-55",    cardName: "Mewtwo GX",     setName: "Sun & Moon",   cardNumber: "55/149",   rarity: "Ultra Rare",              yearManufactured: "2017", lastSoldPriceUSD: 18.00),
        MockCard(cardID: "swsh1-25",  cardName: "Rillaboom",     setName: "Sword & Shield", cardNumber: "14/202", rarity: "Rare Holo",               yearManufactured: "2020", lastSoldPriceUSD: 4.00),
        MockCard(cardID: "sv1-178",   cardName: "Miraidon ex",   setName: "Scarlet & Violet", cardNumber: "178/198", rarity: "Double Rare",          yearManufactured: "2023", lastSoldPriceUSD: 9.00),
        MockCard(cardID: "sv2-167",   cardName: "Arcanine ex",   setName: "Paldea Evolved", cardNumber: "167/193", rarity: "Ultra Rare",             yearManufactured: "2023", lastSoldPriceUSD: 22.00),
        MockCard(cardID: "base1-58",  cardName: "Magmar",        setName: "Base Set",     cardNumber: "58/102",   rarity: "Uncommon",                yearManufactured: "1999", lastSoldPriceUSD: 1.50),
        MockCard(cardID: "sv3-123",   cardName: "Tyranitar ex",  setName: "Obsidian Flames", cardNumber: "123/197", rarity: "Double Rare",           yearManufactured: "2023", lastSoldPriceUSD: 7.50),
    ]

    // MARK: Mock expansions
    var expansions: [String] {
        Array(Set(catalog.map(\.setName))).sorted()
    }

    // MARK: Lookup
    func card(byID id: String) -> MockCard? {
        catalog.first { $0.cardID == id }
    }

    // MARK: Random sample for scan simulation
    func randomCards(count: Int = 5) -> [MockCard] {
        var shuffled = catalog.shuffled()
        return Array(shuffled.prefix(count))
    }

    // MARK: Pricing update placeholder
    /// Replace this with a real HTTP call to your pricing backend.
    func fetchLastSoldPrice(cardID: String, completion: @escaping (Double?) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            completion(self.catalog.first { $0.cardID == cardID }?.lastSoldPriceUSD)
        }
    }

    // MARK: Finish confidence simulation
    /// Simulates the CV model output. Replace with a real CoreML inference call.
    func simulateFinishDetection(for card: MockCard) -> (finish: Finish, confidence: Double) {
        let tier = RarityTier.from(rarityString: card.rarity)
        switch tier {
        case .secretRare, .sirAltArt, .ultraRare:
            return (.holo, Double.random(in: 0.82...0.99))
        case .rareHolo:
            // Sometimes reverse holo, sometimes holo, simulate uncertainty
            let roll = Double.random(in: 0...1)
            if roll < 0.45 {
                return (.reverseHolo, Double.random(in: 0.50...0.75))
            } else {
                return (.holo, Double.random(in: 0.72...0.95))
            }
        case .illustrationRare, .doubleRare:
            return (.holo, Double.random(in: 0.78...0.96))
        default:
            let roll = Double.random(in: 0...1)
            if roll < 0.15 {
                return (.reverseHolo, Double.random(in: 0.45...0.65))
            } else {
                return (.nonFoil, Double.random(in: 0.80...0.99))
            }
        }
    }
}
