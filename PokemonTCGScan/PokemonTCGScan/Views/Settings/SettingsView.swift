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

    private let languages = ["English", "Japanese", "Korean", "Chinese (Traditional)", "Chinese (Simplified)", "German", "French", "Italian", "Portuguese", "Spanish"]
    private let qualities = ["High", "Medium", "Low"]
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
            .confirmationDialog("Clear all inventory?", isPresented: $showClearConfirm, titleVisibility: .visible) {
                Button("Clear All", role: .destructive) {
                    store.remove(ids: Set(store.items.map(\.id)))
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }

    // MARK: Header
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
            Text("SETTINGS")
                .font(Theme.Font.largeTitle)
                .foregroundColor(Theme.Colors.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, Theme.Spacing.md)
    }

    // MARK: Scan defaults
    private var scanDefaultsSection: some View {
        SettingsCard(title: "Scan Defaults", icon: "camera.fill") {
            Picker("Default Language", selection: $defaultLanguage) {
                ForEach(languages, id: \.self) { lang in
                    Text(lang).tag(lang)
                }
            }
            .pickerStyle(.menu)
            .settingsRowStyle(label: "Default Language", value: defaultLanguage)

            Picker("Default Condition", selection: $defaultConditionRaw) {
                ForEach(CardCondition.allCases) { cond in
                    Text(cond.rawValue).tag(cond.rawValue)
                }
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

    // MARK: Audio
    private var audioSection: some View {
        SettingsCard(title: "Audio Feedback", icon: "speaker.wave.2.fill") {
            Toggle(isOn: $soundEnabled) {
                Label("Scan Sounds", systemImage: "waveform")
                    .foregroundColor(Theme.Colors.textPrimary)
            }
            .tint(Theme.Colors.accentCyan)
        }
    }

    // MARK: Storage
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

    // MARK: Export
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

    // MARK: Danger zone
    private var dangerZone: some View {
        SettingsCard(title: "Danger Zone", icon: "exclamationmark.triangle.fill", iconColor: Theme.Colors.destructiveRed) {
            Button {
                showClearConfirm = true
            } label: {
                HStack {
                    Image(systemName: "trash.fill")
                        .foregroundColor(Theme.Colors.destructiveRed)
                    Text("Clear All Inventory")
                        .foregroundColor(Theme.Colors.destructiveRed)
                    Spacer()
                }
            }
        }
    }

    // MARK: Version footer
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
        if raw.contains("Near mint") { return "NM" }
        if raw.contains("Lightly") { return "LP" }
        if raw.contains("Moderately") { return "MP" }
        if raw.contains("Heavily") { return "HP" }
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
                Image(systemName: icon)
                    .foregroundColor(iconColor)
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
