import SwiftUI

// MARK: - Theme
/// Central design-token system.
/// Swap colours and fonts here; all views automatically update.
enum Theme {

    // MARK: Colours
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
