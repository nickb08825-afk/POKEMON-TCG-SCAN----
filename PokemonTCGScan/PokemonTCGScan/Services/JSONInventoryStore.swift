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
