import SwiftUI

extension Color {
    /// Cria uma cor a partir de um hexadecimal RGB (ex.: "FF1E76" ou "#FF1E76").
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var rgb: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&rgb)

        let red, green, blue: Double
        if cleaned.count == 6 {
            red = Double((rgb >> 16) & 0xFF) / 255
            green = Double((rgb >> 8) & 0xFF) / 255
            blue = Double(rgb & 0xFF) / 255
        } else {
            red = 0; green = 0; blue = 0
        }

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1)
    }
}

/// Cores predefinidas oferecidas ao criar uma categoria.
enum CategoryPalette {
    static let colors: [String] = [
        "FF1E76", "FF2D55", "FF3B30", "FF9500", "FFCC00",
        "34C759", "30B0C7", "32ADE6", "5856D6", "AF52DE",
        "9D1EFF", "8E8E93"
    ]
}
