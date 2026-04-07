# Pokémon TCG Scan

A SwiftUI iOS app for scanning multiple Pokémon TCG cards in one photo and automatically adding them to a master inventory. Designed for bulk eBay listing exports.

## Screenshots / Theme

The app uses a **blue theme** (navy → cobalt gradient) with cyan accents, mirroring the reference Dex-style layout but with original/placeholder assets only. Custom backgrounds and fonts can be swapped in via the centralized `Theme` system.

---

## How to Run

### Requirements
- Xcode 15+ (Swift 5.9)
- iOS 17.0+ deployment target
- No external package dependencies (zero Swift Package Manager dependencies in the MVP)

### Steps
1. **Clone the repo**
   ```bash
   git clone https://github.com/nickb08825-afk/POKEMON-TCG-SCAN----.git
   cd POKEMON-TCG-SCAN----
   ```
2. **Open the project**
   ```bash
   open PokemonTCGScan/PokemonTCGScan.xcodeproj
   ```
3. **Select a simulator or device** (iPhone 14 / 15 recommended)
4. **Build & Run** (`⌘R`)

> No API keys or additional setup needed for the MVP — all data is mocked.

---

## Project Structure

```
PokemonTCGScan/
├── PokemonTCGScan.xcodeproj/
└── PokemonTCGScan/
    ├── App/
    │   ├── PokemonTCGScanApp.swift    ← @main entry point
    │   └── RootTabView.swift          ← 5-tab container
    ├── Theme/
    │   └── Theme.swift                ← Colors, gradients, typography, spacing
    ├── Models/
    │   ├── InventoryItem.swift        ← Full card model + eBay title generator
    │   └── ScanRecord.swift           ← Scan session + per-card crop metadata
    ├── Services/
    │   ├── InventoryStore.swift       ← Protocol abstraction
    │   ├── JSONInventoryStore.swift   ← JSON-file persistence (swap for GRDB later)
    │   ├── MockCatalogService.swift   ← Placeholder catalog + pricing + CV simulation
    │   └── ExportService.swift        ← eBay bulk CSV generator
    └── Views/
        ├── Inventory/
        │   ├── InventoryView.swift    ← Searchable grid/list + export button
        │   └── InventoryItemRow.swift ← Card cell + detail view
        ├── Scan/
        │   ├── ScanView.swift         ← Camera viewport + auto-add + Undo banner
        │   ├── ScanResultsView.swift  ← Per-card finish editor
        │   └── FinishConfirmationView.swift ← Low-confidence finish modal
        ├── Expansions/
        │   └── ExpansionsView.swift
        ├── Collections/
        │   └── CollectionsView.swift
        └── Settings/
            └── SettingsView.swift     ← Defaults, export, clear inventory
```

---

## Features

### Inventory
- Searchable grid **and** list layouts (toggle top-right)
- Filter chips by finish: All / Non-Foil / Holo / Reverse Holo
- Card detail view with all stored fields
- Export to eBay CSV via share sheet

### Scan (MVP — simulated)
- Tap **Scan Cards** to simulate a multi-card photo scan (3–6 random cards from mock catalog)
- Each detected card is **automatically added to inventory**
- An **Undo banner** appears for 5 seconds — tap to remove that batch
- Low-confidence finish cards (< 55%) show a `FinishConfirmationView` before adding
- Finish can also be corrected inline in `ScanResultsView`

### eBay CSV Export
Matches the eBay Trading Card / CCG bulk template exactly:

| Column | Source |
|--------|--------|
| Title (required) | Generated: `Pokemon TCG {Name} {Number} {Set} {Finish} {Rarity} {Lang}` |
| Game (required) | Always `pokemon` |
| Purchase Price | `lastSoldPriceUSD` (blank if nil) |
| Purchase Date MM-DD-YYYY | `scanDate` formatted |
| Card Name / Set / Rarity / Card Number / Language | From catalog |
| Finish | `Non-Foil` or `Holo` (eBay's allowed values) |
| Features | `Reverse Holo` when applicable |
| Graded (Y/N) | From item |
| Card Condition | Only when `Graded = N` |
| Professional Grader / Grade / Certification Number | When `Graded = Y` |
| Year Manufactured | From catalog release year |

Export is available from both **Inventory tab** (top-right icon) and **Settings → Export**.

### Settings
- Default language, condition, and finish confidence threshold
- Sound toggle (audio feedback for rarity tier — hook for `AVAudioEngine`)
- Photo quality and retention policy controls
- Clear all inventory (with confirmation)

---

## Rarity Tier → Hit Threshold Mapping

| Tier | Hit Threshold (USD) |
|------|-------------------|
| Common | $0.50 |
| Uncommon | $2.00 |
| Rare | $3.00 |
| Rare Holo | $5.00 |
| Double Rare / ex / V | $8.00 |
| Ultra Rare / Full Art | $15.00 |
| Illustration Rare | $20.00 |
| Special Illustration Rare / Alt Art | $40.00 |
| Secret Rare / Gold / Hyper | $50.00 |

Cards priced ≥ 2× their tier threshold show green; above threshold → cyan; below → white.

---

## Finish Detection Logic

| Confidence | Behavior |
|-----------|----------|
| ≥ 80% | Accept silently |
| 55–80% | Accept; show small "tap to correct" pill |
| < 55% | Show `FinishConfirmationView` — user must pick Non-Foil / Holo / Reverse Holo |

The threshold is configurable in **Settings → Scan Defaults → Finish Confidence Threshold**.

---

## Where to Plug In CV / OCR

### 1. Card detection + cropping
Replace the `simulateScan()` call in `ScanView.swift` with a real Vision request:

```swift
// ScanView.swift → simulateScan()
// Replace MockCatalogService.shared.randomCards(count:)
// with a VNDetectRectanglesRequest on the captured UIImage,
// then run each crop through your card-identification model.
```

Hook:
- `VNDetectRectanglesRequest` → bounding boxes
- `VNImageRequestHandler` with the captured `CVPixelBuffer`
- Perspective correction via `CIFilter.perspectiveCorrection()`

### 2. Card identification
Replace `MockCatalogService.shared.simulateFinishDetection(for:)` with:
- A CoreML model trained on card artwork, OR
- An OCR pass (`VNRecognizeTextRequest`) to extract card name + number, then query **pokemontcg.io**

```swift
// Services/MockCatalogService.swift → simulateFinishDetection(for:)
// Replace with real CoreML inference:
// let model = try! YourCardClassifier(configuration: .init())
// let input = YourCardClassifierInput(image: cropCVPixelBuffer)
// let output = try! model.prediction(input: input)
```

### 3. pokemontcg.io API sync
Replace `MockCatalogService.catalog` with a live API client:

```swift
// GET https://api.pokemontcg.io/v2/cards?q=name:{name}+number:{number}
// Authorization: X-Api-Key YOUR_KEY
// Map the JSON response to MockCard / InventoryItem
```

### 4. Last-sold price feed
Replace `MockCatalogService.fetchLastSoldPrice(cardID:completion:)` with your chosen data source:
- TCGplayer API (requires seller account)
- Your own price-tracking backend

### 5. Switching from JSON → SQLite (GRDB)
Implement the `InventoryStore` protocol with a GRDB-backed store:

```swift
// Create: GRDBInventoryStore: InventoryStore
// In PokemonTCGScanApp.swift swap:
// @StateObject private var store = JSONInventoryStore()
// → @StateObject private var store = GRDBInventoryStore()
```

No view changes needed.

---

## Adding Custom Assets

### Backgrounds
Drop PNG/PDF into `Assets.xcassets` and reference via:
```swift
Image("YourBackgroundName")
    .resizable()
    .ignoresSafeArea()
```
Replace `Theme.Gradients.heroBackground` usages with the `Image` view.

### Custom Fonts
1. Add `.ttf`/`.otf` to `PokemonTCGScan/Resources/`
2. Register in `Info.plist` under `UIAppFonts`
3. Update `Theme.Font.*` to use `Font.custom("YourFontName", size: 34)`

### Colors
All colours live in `Theme.Colors`. Change hex values there; all views update automatically.

---

## License

This project uses only original code and placeholder assets (SF Symbols, gradients). No copyrighted Pokémon artwork, logos, or data is included. Pokémon and all related names are trademarks of Nintendo / Creatures Inc. / GAME FREAK inc.
