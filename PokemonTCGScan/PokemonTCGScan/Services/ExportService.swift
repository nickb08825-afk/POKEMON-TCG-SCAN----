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
