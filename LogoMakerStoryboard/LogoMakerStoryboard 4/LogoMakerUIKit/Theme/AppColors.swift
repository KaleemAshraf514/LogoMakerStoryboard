import UIKit

enum AppColors {
    static let gradientStart = UIColor(hex: "#7B2FF7")
    static let gradientEnd = UIColor(hex: "#F02FC2")
    static let screenBackground = UIColor.dynamic(light: UIColor(hex: "#F5F5F8"), dark: UIColor(hex: "#0D0D10"))
    static let cardBackground = UIColor.dynamic(light: .white, dark: UIColor(hex: "#1C1C1E"))
    static let sideMenuBackground = UIColor.dynamic(light: .white, dark: UIColor(hex: "#151517"))
    static let primaryText = UIColor.dynamic(light: UIColor(hex: "#1A1A1E"), dark: .white)
    static let secondaryText = UIColor.dynamic(light: UIColor(hex: "#8A8A8E"), dark: UIColor(hex: "#9B9BA1"))
    static let separator = UIColor.dynamic(light: UIColor(hex: "#E7E7EA"), dark: UIColor(hex: "#2C2C2E"))
    static let favouriteHeartInactive = UIColor.dynamic(light: UIColor(hex: "#D0D0D5"), dark: UIColor(hex: "#4A4A4E"))
    static let favouriteHeartActive = UIColor(hex: "#FF3B5C")
    static let newBadge = UIColor(hex: "#28C76F")
}
