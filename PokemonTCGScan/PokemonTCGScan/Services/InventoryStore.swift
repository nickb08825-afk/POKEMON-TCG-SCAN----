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
