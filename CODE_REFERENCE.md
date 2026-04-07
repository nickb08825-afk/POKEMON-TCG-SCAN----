# Pokémon TCG Scan — Complete Source Code Reference

This file contains the full source code for every file in the app.
Use it as a reference when creating a digital download package.

**Tech stack:** Swift 5.9 · SwiftUI · iOS 17+ · No external dependencies  
**Xcode:** 15+  **Bundle ID:** `com.tcgscan.PokemonTCGScan`

---

## Table of Contents

1. [Project Structure](#project-structure)
2. [App Entry Point](#1-app-entry-point)
   - [PokemonTCGScanApp.swift](#pokemontcgscanappswift)
   - [RootTabView.swift](#roottabviewswift)
3. [Theme](#2-theme)
   - [Theme.swift](#themeswift)
4. [Models](#3-models)
   - [InventoryItem.swift](#inventoryitemswift)
   - [ScanRecord.swift](#scanrecordswift)
5. [Services](#4-services)
   - [InventoryStore.swift](#inventorystoreswift)
   - [JSONInventoryStore.swift](#jsoninventorystoreswift)
   - [MockCatalogService.swift](#mockcatalogserviceswift)
   - [ExportService.swift](#exportserviceswift)
6. [Views — Inventory](#5-views--inventory)
   - [InventoryView.swift](#inventoryviewswift)
   - [InventoryItemRow.swift](#inventoryitemrowswift)
7. [Views — Scan](#6-views--scan)
   - [ScanView.swift](#scanviewswift)
   - [ScanResultsView.swift](#scanresultsviewswift)
   - [FinishConfirmationView.swift](#finishconfirmationviewswift)
8. [Views — Expansions](#7-views--expansions)
   - [ExpansionsView.swift](#expansionsviewswift)
9. [Views — Collections](#8-views--collections)
   - [CollectionsView.swift](#collectionsviewswift)
10. [Views — Settings](#9-views--settings)
    - [SettingsView.swift](#settingsviewswift)
11. [Resources](#10-resources)
    - [Info.plist](#infoplist)

---

## Project Structure

```
PokemonTCGScan/
├── PokemonTCGScan.xcodeproj/
│   └── project.pbxproj
└── PokemonTCGScan/
    ├── App/
    │   ├── PokemonTCGScanApp.swift
    │   └── RootTabView.swift
    ├── Theme/
    │   └── Theme.swift
    ├── Models/
    │   ├── InventoryItem.swift
    │   └── ScanRecord.swift
    ├── Services/
    │   ├── InventoryStore.swift
    │   ├── JSONInventoryStore.swift
    │   ├── MockCatalogService.swift
    │   └── ExportService.swift
    ├── Views/
    │   ├── Inventory/
    │   │   ├── InventoryView.swift
    │   │   └── InventoryItemRow.swift
    │   ├── Scan/
    │   │   ├── ScanView.swift
    │   │   ├── ScanResultsView.swift
    │   │   └── FinishConfirmationView.swift
    │   ├── Expansions/
    │   │   └── ExpansionsView.swift
    │   ├── Collections/
    │   │   └── CollectionsView.swift
    │   └── Settings/
    │       └── SettingsView.swift
    ├── Assets.xcassets/
    └── Resources/
        └── Info.plist
```

---

## 1. App Entry Point

### PokemonTCGScanApp.swift
**Path:** `PokemonTCGScan/PokemonTCGScan/App/PokemonTCGScanApp.swift`

```swift
import SwiftUI

@main
struct PokemonTCGScanApp: App {
    @StateObject private var store = JSONInventoryStore()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(store)
                .preferredColorScheme(.dark)
        }
    }
}
```

---

### RootTabView.swift
**Path:** `PokemonTCGScan/PokemonTCGScan/App/RootTabView.swift`

```swift
import SwiftUI

struct RootTabView: View {
    @EnvironmentObject var store: JSONInventoryStore

    var body: some View {
        TabView {
            InventoryView()
                .tabItem {
                    Label("Inventory", systemImage: "square.grid.2x2.fill")
                }

            ExpansionsView()
                .tabItem {
                    Label("Expansions", systemImage: "books.vertical.fill")
                }

            CollectionsView()
                .tabItem {
                    Label("Collections", systemImage: "folder.fill")
                }

            ScanView()
                .tabItem {
                    Label("Scan", systemImage: "camera.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .tint(Theme.Colors.accentCyan)
        .background(Theme.Colors.background)
    }
}
```

---

## 2. Theme

### Theme.swift
**Path:** `PokemonTCGScan/PokemonTCGScan/Theme/Theme.swift`

```swift
import SwiftUI

// MARK: - Theme
/// Central design-token system.
/// Swap colors and fonts here; all views automatically update.
enum Theme {

    // MARK: Colors
    enum Colors {
        static let primaryBlue      = Color(hex: "#0B5FFF")
        static let accentCyan       = Color(hex: "#22D3EE")
        static let navyDark         = Color(hex: "#05194A")
        static let cobaltMid        = Color(hex: "#1B3FA0")
        static let background       = Color(hex: "#0A0F2E")
        static let surfaceCard      = Color.white
        static let textPrimary      = Color.white
        static let textSecondary    = Color(hex: "#A0B4D6")
        static let textOnLight      = Color(hex: "#05194A")
        static let scanOverlay      = Color.black.opacity(0.55)
        static let positiveGreen    = Color(hex: "#22C55E")
        static let warningAmber     = Color(hex: "#F59E0B")
        static let destructiveRed   = Color(hex: "#EF4444")
        static let undoBanner       = Color(hex: "#1E3A5F")
    }

    // MARK: Gradients
    enum Gradients {
        static let heroBackground = LinearGradient(
            colors: [Colors.navyDark, Colors.cobaltMid],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        static let cardShimmer = LinearGradient(
            colors: [Colors.primaryBlue.opacity(0.4), Colors.accentCyan.opacity(0.2)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        static let scanViewport = LinearGradient(
            colors: [Colors.navyDark, Colors.background],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // MARK: Typography
    enum Font {
        static let largeTitle  = SwiftUI.Font.system(size: 34, weight: .heavy, design: .rounded)
        static let title       = SwiftUI.Font.system(size: 24, weight: .bold,  design: .rounded)
        static let headline    = SwiftUI.Font.system(size: 18, weight: .semibold, design: .rounded)
        static let body        = SwiftUI.Font.system(size: 15, weight: .regular,  design: .default)
        static let caption     = SwiftUI.Font.system(size: 12, weight: .regular,  design: .default)
        static let price       = SwiftUI.Font.system(size: 20, weight: .bold, design: .monospaced)
        static let cardNumber  = SwiftUI.Font.system(size: 12, weight: .medium, design: .monospaced)
    }

    // MARK: Spacing
    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
    }

    // MARK: Radius
    enum Radius {
        static let card: CGFloat   = 16
        static let button: CGFloat = 12
        static let chip: CGFloat   = 8
    }
}

// MARK: - Color hex init
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red:   Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
```

---

## 3. Models

### InventoryItem.swift
**Path:** `PokemonTCGScan/PokemonTCGScan/Models/InventoryItem.swift`

```swift
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
    case nearMint         = "Near mint or better"
    case lightlyPlayed    = "Lightly played (Excellent)"
    case moderatelyPlayed = "Moderately played (Very good)"
    case heavilyPlayed    = "Heavily played (Poor)"

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
```

---

### ScanRecord.swift
**Path:** `PokemonTCGScan/PokemonTCGScan/Models/ScanRecord.swift`

```swift
import Foundation

// MARK: - ScanRecord
/// One "scan session" = one photo taken by the user
struct ScanRecord: Identifiable, Codable {
    var id: UUID = UUID()
    var capturedAt: Date = Date()
    var originalPhotoPath: String?
    var originalPhotoThumbnailPath: String?
    var catalogVersion: String?
    var pricingVersion: String?
    var priceUpdatedAt: Date?
    var cardCrops: [CardCrop] = []
}

// MARK: - CardCrop
/// One perspective-corrected card crop extracted from a ScanRecord
struct CardCrop: Identifiable, Codable {
    var id: UUID = UUID()
    var scanID: UUID
    var cropImagePath: String?
    var boundingBox: CGRectCodable?     // bounding box in original photo coords
    var rotationDegrees: Double = 0
}

// MARK: - CGRectCodable
/// Codable wrapper for CGRect so ScanRecord + CardCrop are fully Codable
struct CGRectCodable: Codable {
    var x: Double
    var y: Double
    var width: Double
    var height: Double
}
```

---

## 4. Services

### InventoryStore.swift
**Path:** `PokemonTCGScan/PokemonTCGScan/Services/InventoryStore.swift`

```swift
import Foundation
import Combine

// MARK: - InventoryStore Protocol
/// Abstraction so persistence backend can be swapped (JSON → SQLite/GRDB, etc.)
protocol InventoryStore: ObservableObject {
    var items: [InventoryItem] { get }
    func add(_ items: [InventoryItem])
    func remove(ids: Set<UUID>)
    func update(_ item: InventoryItem)
    func save()
}
```

---

### JSONInventoryStore.swift
**Path:** `PokemonTCGScan/PokemonTCGScan/Services/JSONInventoryStore.swift`

```swift
import Foundation
import Combine

// MARK: - JSONInventoryStore
/// Simple JSON-file-backed implementation of InventoryStore.
/// Swap this out for a GRDB/SQLite store without changing any view code.
final class JSONInventoryStore: InventoryStore {

    @Published private(set) var items: [InventoryItem] = []

    private let fileURL: URL

    init(fileURL: URL? = nil) {
        if let url = fileURL {
            self.fileURL = url
        } else {
            let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            self.fileURL = docs.appendingPathComponent("inventory.json")
        }
        load()
    }

    // MARK: InventoryStore
    func add(_ newItems: [InventoryItem]) {
        items.append(contentsOf: newItems)
        save()
    }

    func remove(ids: Set<UUID>) {
        items.removeAll { ids.contains($0.id) }
        save()
    }

    func update(_ item: InventoryItem) {
        if let idx = items.firstIndex(where: { $0.id == item.id }) {
            items[idx] = item
            save()
        }
    }

    func save() {
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("[JSONInventoryStore] Save failed: \(error)")
        }
    }

    // MARK: Private
    private func load() {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return }
        do {
            let data = try Data(contentsOf: fileURL)
            items = try JSONDecoder().decode([InventoryItem].self, from: data)
        } catch {
            print("[JSONInventoryStore] Load failed: \(error)")
        }
    }
}
```

---

### MockCatalogService.swift
**Path:** `PokemonTCGScan/PokemonTCGScan/Services/MockCatalogService.swift`

```swift
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
        MockCard(cardID: "base1-4",   cardName: "Charizard",     setName: "Base Set",        cardNumber: "4/102",    rarity: "Rare Holo",                 yearManufactured: "1999", lastSoldPriceUSD: 350.00),
        MockCard(cardID: "base1-6",   cardName: "Gyarados",      setName: "Base Set",        cardNumber: "6/102",    rarity: "Rare Holo",                 yearManufactured: "1999", lastSoldPriceUSD: 65.00),
        MockCard(cardID: "swsh9-184", cardName: "Umbreon VMAX",  setName: "Brilliant Stars", cardNumber: "184/172",  rarity: "Secret Rare",               yearManufactured: "2022", lastSoldPriceUSD: 120.00),
        MockCard(cardID: "sv3-198",   cardName: "Gardevoir ex",  setName: "Obsidian Flames", cardNumber: "198/197",  rarity: "Special Illustration Rare", yearManufactured: "2023", lastSoldPriceUSD: 95.00),
        MockCard(cardID: "sv4-232",   cardName: "Charizard ex",  setName: "Paradox Rift",    cardNumber: "232/182",  rarity: "Special Illustration Rare", yearManufactured: "2023", lastSoldPriceUSD: 180.00),
        MockCard(cardID: "xy1-45",    cardName: "Pikachu",       setName: "XY Base",         cardNumber: "45/146",   rarity: "Common",                    yearManufactured: "2014", lastSoldPriceUSD: 0.50),
        MockCard(cardID: "sm1-55",    cardName: "Mewtwo GX",     setName: "Sun & Moon",      cardNumber: "55/149",   rarity: "Ultra Rare",                yearManufactured: "2017", lastSoldPriceUSD: 18.00),
        MockCard(cardID: "swsh1-25",  cardName: "Rillaboom",     setName: "Sword & Shield",  cardNumber: "14/202",   rarity: "Rare Holo",                 yearManufactured: "2020", lastSoldPriceUSD: 4.00),
        MockCard(cardID: "sv1-178",   cardName: "Miraidon ex",   setName: "Scarlet & Violet",cardNumber: "178/198",  rarity: "Double Rare",               yearManufactured: "2023", lastSoldPriceUSD: 9.00),
        MockCard(cardID: "sv2-167",   cardName: "Arcanine ex",   setName: "Paldea Evolved",  cardNumber: "167/193",  rarity: "Ultra Rare",                yearManufactured: "2023", lastSoldPriceUSD: 22.00),
        MockCard(cardID: "base1-58",  cardName: "Magmar",        setName: "Base Set",        cardNumber: "58/102",   rarity: "Uncommon",                  yearManufactured: "1999", lastSoldPriceUSD: 1.50),
        MockCard(cardID: "sv3-123",   cardName: "Tyranitar ex",  setName: "Obsidian Flames", cardNumber: "123/197",  rarity: "Double Rare",               yearManufactured: "2023", lastSoldPriceUSD: 7.50),
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
```

---

### ExportService.swift
**Path:** `PokemonTCGScan/PokemonTCGScan/Services/ExportService.swift`

```swift
import Foundation

// MARK: - ExportService
/// Generates an eBay bulk-listing CSV from a collection of InventoryItems.
/// Header matches the provided eBay Trading Card / CCG template exactly.
struct ExportService {

    static let csvHeader = [
        "Title (required field)",
        "Game (required field)",
        "Purchase Price (Price in USD, numbers only)",
        "Purchase Date MM-DD-YYYY",
        "Card Name",
        "Set",
        "Rarity",
        "Finish",
        "Card Number",
        "Language",
        "Graded (Y/N)",
        "Card Condition",
        "Professional Grader",
        "Grade",
        "Certification Number",
        "Features",
        "Year Manufactured"
    ].joined(separator: ",")

    // MARK: - Generate CSV string
    static func generateCSV(from items: [InventoryItem]) -> String {
        var lines: [String] = [csvHeader]
        for item in items {
            lines.append(row(for: item))
        }
        return lines.joined(separator: "\n")
    }

    // MARK: - Write to temp file
    static func writeCSV(_ csv: String, filename: String = "pokemon_tcg_inventory.csv") -> URL? {
        let tmp = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        do {
            try csv.write(to: tmp, atomically: true, encoding: .utf8)
            return tmp
        } catch {
            print("[ExportService] Write failed: \(error)")
            return nil
        }
    }

    // MARK: - Private helpers
    private static func row(for item: InventoryItem) -> String {
        let purchasePrice: String
        if let price = item.lastSoldPriceUSD {
            purchasePrice = String(format: "%.2f", price)
        } else {
            purchasePrice = ""
        }

        let features = item.finish.ebayFeatures

        let columns: [String] = [
            escape(item.ebayTitle),
            "pokemon",
            purchasePrice,
            item.scanDateFormatted,
            escape(item.cardName),
            escape(item.setName),
            escape(item.rarity),
            item.finish.ebayFinish,
            escape(item.cardNumber),
            escape(item.language),
            item.graded ? "Y" : "N",
            item.graded ? "" : escape(item.condition.rawValue),
            escape(item.professionalGrader ?? ""),
            escape(item.grade ?? ""),
            escape(item.certificationNumber ?? ""),
            escape(features),
            escape(item.yearManufactured ?? "")
        ]
        return columns.joined(separator: ",")
    }

    /// Wrap in double-quotes and escape any embedded quotes (RFC 4180)
    private static func escape(_ value: String) -> String {
        if value.contains(",") || value.contains("\"") || value.contains("\n") {
            return "\"" + value.replacingOccurrences(of: "\"", with: "\"\"") + "\""
        }
        return value
    }
}
```

---

## 5. Views — Inventory

### InventoryView.swift
**Path:** `PokemonTCGScan/PokemonTCGScan/Views/Inventory/InventoryView.swift`

```swift
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
```

---

### InventoryItemRow.swift
**Path:** `PokemonTCGScan/PokemonTCGScan/Views/Inventory/InventoryItemRow.swift`

```swift
import SwiftUI

// MARK: - InventoryItemRow (list layout)
struct InventoryItemRow: View {
    let item: InventoryItem

    var body: some View {
        HStack(spacing: Theme.Spacing.sm) {
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
```

---

## 6. Views — Scan

### ScanView.swift
**Path:** `PokemonTCGScan/PokemonTCGScan/Views/Scan/ScanView.swift`

```swift
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
            .sheet(isPresented: $showResults) {
                ScanResultsView(results: scanResults) { approvedResults in
                    scanResults = approvedResults
                    showResults = false
                    addToInventory(scanResults)
                }
            }
            .sheet(isPresented: $showConfirmation) {
                if let card = nextPendingCard {
                    FinishConfirmationView(card: card) { confirmedFinish in
                        if let idx = scanResults.firstIndex(where: { $0.id == card.id }) {
                            scanResults[idx].finish = confirmedFinish
                            scanResults[idx].finishSource = .userConfirmed
                        }
                        if nextPendingCard != nil {
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
                showResults = true
            } else {
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
                Path { p in
                    p.move(to: CGPoint(x: 24, y: 24 + l))
                    p.addLine(to: CGPoint(x: 24, y: 24))
                    p.addLine(to: CGPoint(x: 24 + l, y: 24))
                }.stroke(color, lineWidth: t)
                Path { p in
                    p.move(to: CGPoint(x: w - 24 - l, y: 24))
                    p.addLine(to: CGPoint(x: w - 24, y: 24))
                    p.addLine(to: CGPoint(x: w - 24, y: 24 + l))
                }.stroke(color, lineWidth: t)
                Path { p in
                    p.move(to: CGPoint(x: 24, y: h - 24 - l))
                    p.addLine(to: CGPoint(x: 24, y: h - 24))
                    p.addLine(to: CGPoint(x: 24 + l, y: h - 24))
                }.stroke(color, lineWidth: t)
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
```

---

### ScanResultsView.swift
**Path:** `PokemonTCGScan/PokemonTCGScan/Views/Scan/ScanResultsView.swift`

```swift
import SwiftUI

// MARK: - ScanResultsView
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
```

---

### FinishConfirmationView.swift
**Path:** `PokemonTCGScan/PokemonTCGScan/Views/Scan/FinishConfirmationView.swift`

```swift
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

                    ZStack {
                        Theme.Gradients.cardShimmer
                        Image(systemName: "photo")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.3))
                    }
                    .frame(width: 140, height: 196)
                    .cornerRadius(Theme.Radius.card)

                    VStack(spacing: Theme.Spacing.sm) {
                        ForEach(Finish.allCases) { finish in
                            FinishOptionButton(finish: finish, isSelected: selected == finish) {
                                selected = finish
                            }
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.md)

                    Spacer()

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
```

---

## 7. Views — Expansions

### ExpansionsView.swift
**Path:** `PokemonTCGScan/PokemonTCGScan/Views/Expansions/ExpansionsView.swift`

```swift
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
```

---

## 8. Views — Collections

### CollectionsView.swift
**Path:** `PokemonTCGScan/PokemonTCGScan/Views/Collections/CollectionsView.swift`

```swift
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
            Text("Organize your cards into groups")
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
        CollectionItem(name: "Base Set Hits", cardCount: 12, iconName: "sparkles",                   color: Theme.Colors.accentCyan),
        CollectionItem(name: "Japanese",      cardCount: 8,  iconName: "globe.asia.australia.fill",  color: Color(hex: "#A78BFA")),
        CollectionItem(name: "Holos",         cardCount: 24, iconName: "sparkles",                   color: Theme.Colors.positiveGreen),
        CollectionItem(name: "Graded PSA",    cardCount: 3,  iconName: "shield.fill",                color: Theme.Colors.warningAmber),
    ]
}

// MARK: - NewCollectionTile
struct NewCollectionTile: View {
    var body: some View {
        VStack(spacing: Theme.Spacing.sm) {
            ZStack {
                Circle()
                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6]))
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
                .stroke(Theme.Colors.primaryBlue.opacity(0.3),
                        style: StrokeStyle(lineWidth: 1.5, dash: [6]))
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
```

---

## 9. Views — Settings

### SettingsView.swift
**Path:** `PokemonTCGScan/PokemonTCGScan/Views/Settings/SettingsView.swift`

```swift
import SwiftUI

struct SettingsView: View {
    @AppStorage("defaultLanguage")  private var defaultLanguage = "English"
    @AppStorage("defaultCondition") private var defaultConditionRaw = CardCondition.nearMint.rawValue
    @AppStorage("soundEnabled")     private var soundEnabled = true
    @AppStorage("photoQuality")     private var photoQuality = "Medium"
    @AppStorage("keepOriginals")    private var keepOriginals = "Forever"
    @AppStorage("lowConfThreshold") private var lowConfThreshold = 0.55

    @EnvironmentObject var store: JSONInventoryStore
    @State private var showExportSheet = false
    @State private var exportURL: URL? = nil
    @State private var showClearConfirm = false

    private let languages = ["English", "Japanese", "Korean", "Chinese (Traditional)",
                             "Chinese (Simplified)", "German", "French", "Italian",
                             "Portuguese", "Spanish"]
    private let qualities   = ["High", "Medium", "Low"]
    private let keepOptions = ["Forever", "90 days", "30 days", "7 days"]

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Gradients.heroBackground.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: Theme.Spacing.md) {
                        headerSection
                        scanDefaultsSection
                        audioSection
                        storageSection
                        exportSection
                        dangerZone
                        versionFooter
                    }
                    .padding(Theme.Spacing.md)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showExportSheet) {
                if let url = exportURL {
                    ShareSheet(activityItems: [url])
                }
            }
            .confirmationDialog("Clear all inventory?", isPresented: $showClearConfirm,
                                titleVisibility: .visible) {
                Button("Clear All", role: .destructive) {
                    store.remove(ids: Set(store.items.map(\.id)))
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
            Text("SETTINGS")
                .font(Theme.Font.largeTitle)
                .foregroundColor(Theme.Colors.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, Theme.Spacing.md)
    }

    private var scanDefaultsSection: some View {
        SettingsCard(title: "Scan Defaults", icon: "camera.fill") {
            Picker("Default Language", selection: $defaultLanguage) {
                ForEach(languages, id: \.self) { lang in Text(lang).tag(lang) }
            }
            .pickerStyle(.menu)
            .settingsRowStyle(label: "Default Language", value: defaultLanguage)

            Picker("Default Condition", selection: $defaultConditionRaw) {
                ForEach(CardCondition.allCases) { cond in Text(cond.rawValue).tag(cond.rawValue) }
            }
            .pickerStyle(.menu)
            .settingsRowStyle(label: "Default Condition", value: shortCondition(defaultConditionRaw))

            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                HStack {
                    Text("Finish Confidence Threshold")
                        .font(Theme.Font.body)
                        .foregroundColor(Theme.Colors.textPrimary)
                    Spacer()
                    Text("\(Int(lowConfThreshold * 100))%")
                        .font(Theme.Font.cardNumber)
                        .foregroundColor(Theme.Colors.accentCyan)
                }
                Slider(value: $lowConfThreshold, in: 0.3...0.9, step: 0.05)
                    .tint(Theme.Colors.accentCyan)
                Text("Ask for confirmation when confidence < \(Int(lowConfThreshold * 100))%")
                    .font(Theme.Font.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            .padding(.vertical, Theme.Spacing.xs)
        }
    }

    private var audioSection: some View {
        SettingsCard(title: "Audio Feedback", icon: "speaker.wave.2.fill") {
            Toggle(isOn: $soundEnabled) {
                Label("Scan Sounds", systemImage: "waveform")
                    .foregroundColor(Theme.Colors.textPrimary)
            }
            .tint(Theme.Colors.accentCyan)
        }
    }

    private var storageSection: some View {
        SettingsCard(title: "Photo Storage", icon: "photo.stack.fill") {
            Picker("Photo Quality", selection: $photoQuality) {
                ForEach(qualities, id: \.self) { Text($0).tag($0) }
            }
            .pickerStyle(.menu)
            .settingsRowStyle(label: "Photo Quality", value: photoQuality)

            Picker("Keep Originals", selection: $keepOriginals) {
                ForEach(keepOptions, id: \.self) { Text($0).tag($0) }
            }
            .pickerStyle(.menu)
            .settingsRowStyle(label: "Keep Originals", value: keepOriginals)
        }
    }

    private var exportSection: some View {
        SettingsCard(title: "Export", icon: "square.and.arrow.up.fill") {
            Button {
                let csv = ExportService.generateCSV(from: store.items)
                if let url = ExportService.writeCSV(csv) {
                    exportURL = url
                    showExportSheet = true
                }
            } label: {
                HStack {
                    Image(systemName: "tablecells")
                        .foregroundColor(Theme.Colors.accentCyan)
                    Text("Export eBay CSV (\(store.items.count) items)")
                        .foregroundColor(Theme.Colors.textPrimary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(Theme.Colors.textSecondary)
                }
            }
        }
    }

    private var dangerZone: some View {
        SettingsCard(title: "Danger Zone", icon: "exclamationmark.triangle.fill",
                     iconColor: Theme.Colors.destructiveRed) {
            Button {
                showClearConfirm = true
            } label: {
                HStack {
                    Image(systemName: "trash.fill").foregroundColor(Theme.Colors.destructiveRed)
                    Text("Clear All Inventory").foregroundColor(Theme.Colors.destructiveRed)
                    Spacer()
                }
            }
        }
    }

    private var versionFooter: some View {
        VStack(spacing: 4) {
            Text("Pokémon TCG Scan")
                .font(Theme.Font.caption)
                .foregroundColor(Theme.Colors.textSecondary)
            Text("v1.0.0 — MVP Scaffold")
                .font(Theme.Font.caption)
                .foregroundColor(Theme.Colors.textSecondary.opacity(0.6))
            Text("CV/OCR + pokemontcg.io sync not yet connected")
                .font(.system(size: 10))
                .foregroundColor(Theme.Colors.textSecondary.opacity(0.4))
        }
        .padding(.top, Theme.Spacing.md)
    }

    private func shortCondition(_ raw: String) -> String {
        if raw.contains("Near mint")    { return "NM" }
        if raw.contains("Lightly")      { return "LP" }
        if raw.contains("Moderately")   { return "MP" }
        if raw.contains("Heavily")      { return "HP" }
        return raw
    }
}

// MARK: - SettingsCard
struct SettingsCard<Content: View>: View {
    let title: String
    let icon: String
    var iconColor: Color = Theme.Colors.accentCyan
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack(spacing: Theme.Spacing.sm) {
                Image(systemName: icon).foregroundColor(iconColor)
                Text(title)
                    .font(Theme.Font.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
            }
            Divider().background(Color.white.opacity(0.1))
            content
        }
        .padding(Theme.Spacing.md)
        .background(Color.white.opacity(0.08))
        .cornerRadius(Theme.Radius.card)
    }
}

// MARK: - ViewModifier for settings rows
extension View {
    func settingsRowStyle(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(Theme.Font.body)
                .foregroundColor(Theme.Colors.textPrimary)
            Spacer()
            Text(value)
                .font(Theme.Font.caption)
                .foregroundColor(Theme.Colors.textSecondary)
            self
                .labelsHidden()
                .accentColor(Theme.Colors.accentCyan)
        }
    }
}

// MARK: - ShareSheet
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uvc: UIActivityViewController, context: Context) {}
}
```

---

## 10. Resources

### Info.plist
**Path:** `PokemonTCGScan/PokemonTCGScan/Resources/Info.plist`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>$(DEVELOPMENT_LANGUAGE)</string>
    <key>CFBundleDisplayName</key>
    <string>TCG Scan</string>
    <key>CFBundleExecutable</key>
    <string>$(EXECUTABLE_NAME)</string>
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>$(PRODUCT_NAME)</string>
    <key>CFBundlePackageType</key>
    <string>$(PRODUCT_BUNDLE_PACKAGE_TYPE)</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSRequiresIPhoneOS</key>
    <true/>
    <key>NSCameraUsageDescription</key>
    <string>TCG Scan uses the camera to photograph Pokémon TCG cards for automatic identification.</string>
    <key>NSPhotoLibraryAddUsageDescription</key>
    <string>TCG Scan saves card scan photos to your photo library.</string>
    <key>NSPhotoLibraryUsageDescription</key>
    <string>TCG Scan reads photos from your library for card scanning.</string>
    <key>UIApplicationSceneManifest</key>
    <dict>
        <key>UIApplicationSupportsMultipleScenes</key>
        <false/>
    </dict>
    <key>UILaunchScreen</key>
    <dict/>
    <key>UIRequiredDeviceCapabilities</key>
    <array>
        <string>arm64</string>
    </array>
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
    <key>UISupportedInterfaceOrientations~ipad</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationPortraitUpsideDown</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
</dict>
</plist>
```

---

## File Count Summary

| Category | Files | Lines (approx.) |
|----------|-------|-----------------|
| App entry + tab root | 2 | ~45 |
| Theme | 1 | ~95 |
| Models | 2 | ~175 |
| Services | 4 | ~185 |
| Inventory views | 2 | ~310 |
| Scan views | 3 | ~490 |
| Expansions view | 1 | ~65 |
| Collections view | 1 | ~135 |
| Settings view | 1 | ~240 |
| Info.plist | 1 | ~50 |
| **Total** | **18** | **~1,790** |

---

*All code is original Swift 5.9 / SwiftUI. No copyrighted artwork is included.
Pokémon and all related names are trademarks of Nintendo / Creatures Inc. / GAME FREAK inc.*
