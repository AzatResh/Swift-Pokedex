import SwiftUI

extension Color {
    
    static let darkGrey = Color(hex: 0x181818)
    static let pokedexRed = Color(hex: 0xD53B47)
    static let cardBackground = Color(hex: 0x202020)
    
//    init?(hex: String, alpha: Double = 1.0) {
//        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
//        hexString = hexString.hasPrefix("#") ? String(hexString.dropFirst()) : hexString
//
//        guard let hexNumber = UInt64(hexString, radix: 16), hexString.count == 6 else { return nil }
//
//        let r = Double((hexNumber & 0xFF0000) >> 16) / 255
//        let g = Double((hexNumber & 0x00FF00) >> 8) / 255
//        let b = Double(hexNumber & 0x0000FF) / 255
//        self = Color(red: r, green: g, blue: b, opacity: alpha)
//    }
    
    init(hex: UInt32) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: 1
        )
    }
    
    
    var isLight: Bool {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        if UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            let brightness = (red * 299 + green * 587 + blue * 114) / 1000
            return brightness > 0.6
        }
        return false
    }
}


enum TypeColor {
    static func color(for name: String?) -> Color {
        switch name {
        case "grass": return .green
        case "electric": return .yellow
        case "psychic":                    return .pink
        case "ice":                        return .cyan
        case "fighting", "rock", "ground": return .brown
        case "poison", "ghost":            return .purple
        case "flying", "fairy":            return .mint
        case "bug":                        return .green.opacity(0.7)
        case "steel":                      return .gray
        case "dark":                       return .black
        case "dragon":                     return .indigo
        default:                           return .gray
        }
    }
}
