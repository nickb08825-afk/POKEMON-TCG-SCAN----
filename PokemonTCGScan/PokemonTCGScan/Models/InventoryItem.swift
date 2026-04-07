import Foundation

// MARK: - Finish
enum Finish: String, Codable, CaseIterable, Identifiable {
    case nonFoil     = "non_foil"
    case holo        = "holo"
    case reverseHolo = "reverse_holo"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .nonFoil:     return "Non-Foil"
        case .holo:        return "Holo"
        case .reverseHolo: return "Reverse Holo"
        }
    }

    /// eBay CSV "Finish" column value
    var ebayFinish: String {
        switch self {
        case .nonFoil:     return "Non-Foil"
        case .holo:        return "Holo"
        case .reverseHolo: return "Holo"
        }
    }

    /// eBay CSV "Features" addition (empty string if none)
    var ebayFeatures: String {
        switch self {
        case .reverseHolo: return "Reverse Holo"
        default:           return ""
        }
    }
}

// MARK: - Finish Source
enum FinishSource: String, Codable {
    case auto          = "auto"
    case userConfirmed = "user_confirmed"
}

// MARK: - Rarity Tier
enum RarityTier: Int, Codable, Comparable {
    case unknown          = 0
    case common           = 1
    case uncommon         = 2
    case rare             = 3
    case rareHolo         = 4
    case doubleRare       = 5
    case ultraRare        = 6
    case illustrationRare = 7
    case sirAltArt        = 8
    case secretRare       = 9

    static func < (lhs: RarityTier, rhs: RarityTier) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    /// USD threshold that marks a "hit" for this rarity tier
    var hitThreshold: Double {
        switch self {
        case .unknown:          return 1.00
        case .common:           return 0.50
        case .uncommon:         return 2.00
        case .rare:             return 3.00
        case .rareHolo:         return 5.00
        case .doubleRare:       return 8.00
        case .ultraRare:        return 15.00
        case .illustrationRare: return 20.00
        case .sirAltArt:        return 40.00
        case .secretRare:       return 50.00
        }
    }

    /// Normalised pitch multiplier (1.0 = base, higher = higher pitch)
    var basePitchMultiplier: Double {
        switch self {
        case .unknown:          return 1.0
        case .common:           return 1.0
        case .uncommon:         return 1.1
        case .rare:             return 1.2
        case .rareHolo:         return 1.35
        case .doubleRare:       return 1.5
        case .ultraRare:        return 1.7
        case .illustrationRare: return 1.9
        case .sirAltArt:        return 2.1
        case .secretRare:       return 2.4
        }
    }

    static func from(rarityString: String) -> RarityTier {
        let s = rarityString.lowercased()
        if s.contains("secret") || s.contains("gold") || s.contains("hyper") { return .secretRare }
        if s.contains("special illustration") || s.contains("alt art") || s.contains("sir") { return .sirAltArt }
        if s.contains("illustration rare") { return .illustrationRare }
        if s.contains("ultra rare") || s.contains("full art") || s.contains("vstar") { return .ultraRare }
        if s.contains("double rare") || s.contains(" ex") || s.contains(" v ") { return .doubleRare }
        if s.contains("holo") { return .rareHolo }
        if s.contains("rare") { return .rare }
        if s.contains("uncommon") { return .uncommon }
        if s.contains("common") { return .common }
        return .unknown
    }
}

// MARK: - Card Condition
enum CardCondition: String, Codable, CaseIterable, Identifiable {
    case nearMint       = "Near mint or better"
    case lightlyPlayed  = "Lightly played (Excellent)"
    case moderatelyPlayed = "Moderately played (Very good)"
    case heavilyPlayed  = "Heavily played (Poor)"

    var id: String { rawValue }
}

// MARK: - InventoryItem
struct InventoryItem: Identifiable, Codable {
    var id: UUID = UUID()

    // Card identity
    var cardName: String
    var setName: String
    var cardNumber: String          // e.g. "4/102" or "TG12/TG30"
    var rarity: String              // raw string from catalog
    var rarityTier: RarityTier

    // Finish
    var finish: Finish
    var finishConfidence: Double    // 0–1
    var finishSource: FinishSource

    // Acquisition / metadata
    var language: String            // default "English"
    var graded: Bool                // default false → "N"
    var condition: CardCondition    // default .nearMint
    var professionalGrader: String? // PSA / BGS / CGC etc.
    var grade: String?              // "10", "9.5" etc.
    var certificationNumber: String?
    var yearManufactured: String?

    // Pricing
    var lastSoldPriceUSD: Double?
    var lastSoldDate: Date?
    var lastSoldSource: String?
    var priceUpdatedAt: Date?

    // Scan linkage
    var scanDate: Date
    var scanID: UUID?
    var cropID: UUID?
    var cropImagePath: String?      // file path / URL string placeholder
    var originalPhotoPath: String?  // file path / URL string placeholder

    // MARK: Generated eBay title
    var ebayTitle: String {
        var parts: [String] = []
        parts.append("Pokemon TCG")
        parts.append(cardName)
        if !cardNumber.isEmpty { parts.append(cardNumber) }
        parts.append(setName)
        if finish == .reverseHolo { parts.append("Reverse Holo") }
        if !rarity.isEmpty { parts.append(rarity) }
        if language != "English" { parts.append(language) }
        if graded, let grader = professionalGrader, let g = grade {
            parts.append("\(grader) \(g)")
        }
        return parts.joined(separator: " ")
    }

    // MARK: Convenience
    var scanDateFormatted: String {
        let f = DateFormatter()
        f.dateFormat = "MM-dd-yyyy"
        return f.string(from: scanDate)
    }
}
