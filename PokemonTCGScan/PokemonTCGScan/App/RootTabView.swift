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
