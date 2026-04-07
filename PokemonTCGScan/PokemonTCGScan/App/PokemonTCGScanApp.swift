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
