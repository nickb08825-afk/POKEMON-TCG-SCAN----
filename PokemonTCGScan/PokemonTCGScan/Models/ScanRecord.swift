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
