import SwiftUI

enum Theme: String, CaseIterable, Identifiable {
  case classic
  case pastelDream
  case monochrome
  case warmEarth
  case coolOcean
  case neonNights
  case sunsetBlaze
  case tropicalParadise
  case electricDream

  var id: String { rawValue }

  var name: String {
    switch self {
    case .classic: return "Classic"
    case .pastelDream: return "Pastel Dream"
    case .monochrome: return "Monochrome"
    case .warmEarth: return "Warm Earth"
    case .coolOcean: return "Cool Ocean"
    case .neonNights: return "Neon Nights"
    case .sunsetBlaze: return "Sunset Blaze"
    case .tropicalParadise: return "Tropical Paradise"
    case .electricDream: return "Electric Dream"
    }
  }

  var description: String {
    switch self {
    case .classic:
      return "Vibrant, standard iOS color palette with bold, energetic tones"
    case .pastelDream:
      return "Soft, muted colors for a calm and approachable aesthetic"
    case .monochrome:
      return "Sophisticated grayscale with subtle color hints"
    case .warmEarth:
      return "Cozy, natural tones inspired by earth and autumn"
    case .coolOcean:
      return "Fresh, serene blues and teals for calm focus"
    case .neonNights:
      return "High-contrast neon colors with a cyberpunk aesthetic"
    case .sunsetBlaze:
      return "Vivid warm hues inspired by golden hour sunsets"
    case .tropicalParadise:
      return "Bright, saturated colors from tropical landscapes"
    case .electricDream:
      return "Bold electric blues, purples, and magentas"
    }
  }

  func colors(for colorScheme: ColorScheme) -> ThemeColors {
    switch colorScheme {
    case .light:
      return lightColors
    case .dark:
      return darkColors
    @unknown default:
      return lightColors
    }
  }

  private var lightColors: ThemeColors {
    switch self {
    case .classic:
      return ThemeColors(
        categoryColors: [
          Color(hex: "#007AFF"),
          Color(hex: "#FF3B30"),
          Color(hex: "#34C759"),
          Color(hex: "#FF9500"),
          Color(hex: "#FFCC00"),
          Color(hex: "#AF52DE"),
          Color(hex: "#FF2D92"),
          Color(hex: "#5AC8FA"),
          Color(hex: "#5856D6"),
          Color(hex: "#00C7BE"),
        ],
        primaryBackground: .white,
        secondaryBackground: Color(white: 0.95),
        primaryText: .black,
        secondaryText: Color(white: 0.4),
        accent: Color(hex: "#007AFF"),
        destructive: Color(hex: "#FF3B30")
      )

    case .pastelDream:
      return ThemeColors(
        categoryColors: [
          Color(hex: "#A8C7FF"),
          Color(hex: "#FFB5B0"),
          Color(hex: "#B5EAC3"),
          Color(hex: "#FFD4A3"),
          Color(hex: "#FFF4B8"),
          Color(hex: "#D4B5E8"),
          Color(hex: "#FFBDD9"),
          Color(hex: "#B5E8F0"),
          Color(hex: "#C4C3F0"),
          Color(hex: "#B3F0E8"),
        ],
        primaryBackground: Color(hex: "#FFFEF8"),
        secondaryBackground: Color(hex: "#F5F3ED"),
        primaryText: Color(hex: "#4A4A4A"),
        secondaryText: Color(hex: "#8A8A8A"),
        accent: Color(hex: "#A8C7FF"),
        destructive: Color(hex: "#FFB5B0")
      )

    case .monochrome:
      return ThemeColors(
        categoryColors: [
          Color(hex: "#6B7B9E"),
          Color(hex: "#8B7B7B"),
          Color(hex: "#7B8B7B"),
          Color(hex: "#8B8270"),
          Color(hex: "#8B8B70"),
          Color(hex: "#7B758B"),
          Color(hex: "#8B7080"),
          Color(hex: "#6B8088"),
          Color(hex: "#70708B"),
          Color(hex: "#6B8580"),
        ],
        primaryBackground: Color(hex: "#F5F5F7"),
        secondaryBackground: Color(hex: "#E5E5E7"),
        primaryText: Color(hex: "#2C2C2E"),
        secondaryText: Color(hex: "#6C6C6E"),
        accent: Color(hex: "#6B7B9E"),
        destructive: Color(hex: "#8B7B7B")
      )

    case .warmEarth:
      return ThemeColors(
        categoryColors: [
          Color(hex: "#6B8EA8"),
          Color(hex: "#C85A4A"),
          Color(hex: "#7A9F6B"),
          Color(hex: "#D98B4A"),
          Color(hex: "#D4B563"),
          Color(hex: "#9B7A8E"),
          Color(hex: "#C87A88"),
          Color(hex: "#6B9B9B"),
          Color(hex: "#7A7A9B"),
          Color(hex: "#6B9B8E"),
        ],
        primaryBackground: Color(hex: "#F9F6F0"),
        secondaryBackground: Color(hex: "#EFEAE0"),
        primaryText: Color(hex: "#3E342E"),
        secondaryText: Color(hex: "#7E6E68"),
        accent: Color(hex: "#D98B4A"),
        destructive: Color(hex: "#C85A4A")
      )

    case .coolOcean:
      return ThemeColors(
        categoryColors: [
          Color(hex: "#4A8FE7"),
          Color(hex: "#7A9FBF"),
          Color(hex: "#5BA89F"),
          Color(hex: "#6FA3BF"),
          Color(hex: "#8FAFC7"),
          Color(hex: "#7A8FC7"),
          Color(hex: "#8F9FBF"),
          Color(hex: "#4FA8C7"),
          Color(hex: "#6A7FC7"),
          Color(hex: "#4FA89F"),
        ],
        primaryBackground: Color(hex: "#F0F8FF"),
        secondaryBackground: Color(hex: "#E0F0FF"),
        primaryText: Color(hex: "#0F3F5F"),
        secondaryText: Color(hex: "#4F6F8F"),
        accent: Color(hex: "#4A8FE7"),
        destructive: Color(hex: "#7A9FBF")
      )

    case .neonNights:
      return ThemeColors(
        categoryColors: [
          Color(hex: "#00D9FF"),
          Color(hex: "#FF006E"),
          Color(hex: "#39FF14"),
          Color(hex: "#FF9E00"),
          Color(hex: "#FFFF00"),
          Color(hex: "#BF40BF"),
          Color(hex: "#FF10F0"),
          Color(hex: "#00FFFF"),
          Color(hex: "#8B00FF"),
          Color(hex: "#00FFA3"),
        ],
        primaryBackground: Color(hex: "#0A0A0A"),
        secondaryBackground: Color(hex: "#1A1A1A"),
        primaryText: Color(hex: "#FFFFFF"),
        secondaryText: Color(hex: "#B0B0B0"),
        accent: Color(hex: "#00D9FF"),
        destructive: Color(hex: "#FF006E")
      )

    case .sunsetBlaze:
      return ThemeColors(
        categoryColors: [
          Color(hex: "#FF6B35"),
          Color(hex: "#FF0054"),
          Color(hex: "#FFB319"),
          Color(hex: "#FF4E00"),
          Color(hex: "#FFCC00"),
          Color(hex: "#D946EF"),
          Color(hex: "#FF007F"),
          Color(hex: "#FF8C42"),
          Color(hex: "#9D4EDD"),
          Color(hex: "#FF5E78"),
        ],
        primaryBackground: Color(hex: "#FFF8F0"),
        secondaryBackground: Color(hex: "#FFE8D6"),
        primaryText: Color(hex: "#2D1B00"),
        secondaryText: Color(hex: "#7D5A3B"),
        accent: Color(hex: "#FF6B35"),
        destructive: Color(hex: "#FF0054")
      )

    case .tropicalParadise:
      return ThemeColors(
        categoryColors: [
          Color(hex: "#00B4D8"),
          Color(hex: "#F72585"),
          Color(hex: "#06FFA5"),
          Color(hex: "#FF8500"),
          Color(hex: "#FFDD00"),
          Color(hex: "#B5179E"),
          Color(hex: "#FF206E"),
          Color(hex: "#48CAE4"),
          Color(hex: "#7209B7"),
          Color(hex: "#00F5D4"),
        ],
        primaryBackground: Color(hex: "#FFFEF7"),
        secondaryBackground: Color(hex: "#F0FAFF"),
        primaryText: Color(hex: "#001D3D"),
        secondaryText: Color(hex: "#4A5568"),
        accent: Color(hex: "#00B4D8"),
        destructive: Color(hex: "#F72585")
      )

    case .electricDream:
      return ThemeColors(
        categoryColors: [
          Color(hex: "#0096FF"),
          Color(hex: "#D946EF"),
          Color(hex: "#7C3AED"),
          Color(hex: "#0EA5E9"),
          Color(hex: "#06B6D4"),
          Color(hex: "#A855F7"),
          Color(hex: "#EC4899"),
          Color(hex: "#3B82F6"),
          Color(hex: "#8B5CF6"),
          Color(hex: "#14B8A6"),
        ],
        primaryBackground: Color(hex: "#F8FAFF"),
        secondaryBackground: Color(hex: "#EEF2FF"),
        primaryText: Color(hex: "#1E1B4B"),
        secondaryText: Color(hex: "#4C1D95"),
        accent: Color(hex: "#0096FF"),
        destructive: Color(hex: "#D946EF")
      )
    }
  }

  private var darkColors: ThemeColors {
    switch self {
    case .classic:
      return ThemeColors(
        categoryColors: [
          Color(hex: "#0A84FF"),
          Color(hex: "#FF453A"),
          Color(hex: "#32D74B"),
          Color(hex: "#FF9F0A"),
          Color(hex: "#FFD60A"),
          Color(hex: "#BF5AF2"),
          Color(hex: "#FF375F"),
          Color(hex: "#64D2FF"),
          Color(hex: "#5E5CE6"),
          Color(hex: "#66D4CF"),
        ],
        primaryBackground: Color(hex: "#1C1C1E"),
        secondaryBackground: Color(hex: "#2C2C2E"),
        primaryText: .white,
        secondaryText: Color(white: 0.7),
        accent: Color(hex: "#0A84FF"),
        destructive: Color(hex: "#FF453A")
      )

    case .pastelDream:
      return ThemeColors(
        categoryColors: [
          Color(hex: "#7AA0E0"),
          Color(hex: "#D88880"),
          Color(hex: "#80C090"),
          Color(hex: "#D8A870"),
          Color(hex: "#D8C880"),
          Color(hex: "#A880C0"),
          Color(hex: "#D890A8"),
          Color(hex: "#80C0D0"),
          Color(hex: "#9898C0"),
          Color(hex: "#80C0B0"),
        ],
        primaryBackground: Color(hex: "#1A1F2E"),
        secondaryBackground: Color(hex: "#252A38"),
        primaryText: Color(hex: "#F0F0F0"),
        secondaryText: Color(hex: "#A0A0A0"),
        accent: Color(hex: "#7AA0E0"),
        destructive: Color(hex: "#D88880")
      )

    case .monochrome:
      return ThemeColors(
        categoryColors: [
          Color(hex: "#8A9ABE"),
          Color(hex: "#9A8A8A"),
          Color(hex: "#8A9A8A"),
          Color(hex: "#9A9280"),
          Color(hex: "#9A9A80"),
          Color(hex: "#8A849A"),
          Color(hex: "#9A8090"),
          Color(hex: "#7A9098"),
          Color(hex: "#80809A"),
          Color(hex: "#7A9590"),
        ],
        primaryBackground: Color(hex: "#1C1C1E"),
        secondaryBackground: Color(hex: "#2C2C2E"),
        primaryText: Color(hex: "#E5E5E7"),
        secondaryText: Color(hex: "#A5A5A7"),
        accent: Color(hex: "#8A9ABE"),
        destructive: Color(hex: "#9A8A8A")
      )

    case .warmEarth:
      return ThemeColors(
        categoryColors: [
          Color(hex: "#7BA0C0"),
          Color(hex: "#D86A5A"),
          Color(hex: "#8AAF7B"),
          Color(hex: "#E99B5A"),
          Color(hex: "#E4C573"),
          Color(hex: "#AB8A9E"),
          Color(hex: "#D88A98"),
          Color(hex: "#7BABAB"),
          Color(hex: "#8A8AAB"),
          Color(hex: "#7BAB9E"),
        ],
        primaryBackground: Color(hex: "#2B2520"),
        secondaryBackground: Color(hex: "#3B3530"),
        primaryText: Color(hex: "#F0E8E0"),
        secondaryText: Color(hex: "#A09080"),
        accent: Color(hex: "#E99B5A"),
        destructive: Color(hex: "#D86A5A")
      )

    case .coolOcean:
      return ThemeColors(
        categoryColors: [
          Color(hex: "#5A9FF7"),
          Color(hex: "#8AAFCF"),
          Color(hex: "#6BB8AF"),
          Color(hex: "#7FB3CF"),
          Color(hex: "#9FBFD7"),
          Color(hex: "#8A9FD7"),
          Color(hex: "#9FAFCF"),
          Color(hex: "#5FB8D7"),
          Color(hex: "#7A8FD7"),
          Color(hex: "#5FB8AF"),
        ],
        primaryBackground: Color(hex: "#0F1F2E"),
        secondaryBackground: Color(hex: "#1F2F3E"),
        primaryText: Color(hex: "#D0E8F0"),
        secondaryText: Color(hex: "#7FA0B0"),
        accent: Color(hex: "#5A9FF7"),
        destructive: Color(hex: "#8AAFCF")
      )

    case .neonNights:
      return ThemeColors(
        categoryColors: [
          Color(hex: "#00FFFF"),
          Color(hex: "#FF1493"),
          Color(hex: "#39FF14"),
          Color(hex: "#FFB700"),
          Color(hex: "#FFFF33"),
          Color(hex: "#DA70D6"),
          Color(hex: "#FF69B4"),
          Color(hex: "#00E5FF"),
          Color(hex: "#9D00FF"),
          Color(hex: "#00FFB3"),
        ],
        primaryBackground: Color(hex: "#000000"),
        secondaryBackground: Color(hex: "#0D0D0D"),
        primaryText: Color(hex: "#FFFFFF"),
        secondaryText: Color(hex: "#C0C0C0"),
        accent: Color(hex: "#00FFFF"),
        destructive: Color(hex: "#FF1493")
      )

    case .sunsetBlaze:
      return ThemeColors(
        categoryColors: [
          Color(hex: "#FF8C61"),
          Color(hex: "#FF3366"),
          Color(hex: "#FFC947"),
          Color(hex: "#FF6B35"),
          Color(hex: "#FFD93D"),
          Color(hex: "#E879F9"),
          Color(hex: "#FF4D94"),
          Color(hex: "#FFA566"),
          Color(hex: "#B565F8"),
          Color(hex: "#FF758F"),
        ],
        primaryBackground: Color(hex: "#1A0F00"),
        secondaryBackground: Color(hex: "#2A1F10"),
        primaryText: Color(hex: "#FFE8D6"),
        secondaryText: Color(hex: "#C9A97A"),
        accent: Color(hex: "#FF8C61"),
        destructive: Color(hex: "#FF3366")
      )

    case .tropicalParadise:
      return ThemeColors(
        categoryColors: [
          Color(hex: "#03DAC6"),
          Color(hex: "#FF4A9E"),
          Color(hex: "#1BFFBB"),
          Color(hex: "#FFA033"),
          Color(hex: "#FFEA00"),
          Color(hex: "#CF6CCE"),
          Color(hex: "#FF4081"),
          Color(hex: "#90E0EF"),
          Color(hex: "#9D4EDD"),
          Color(hex: "#00F5D4"),
        ],
        primaryBackground: Color(hex: "#001219"),
        secondaryBackground: Color(hex: "#051923"),
        primaryText: Color(hex: "#F0F3F5"),
        secondaryText: Color(hex: "#94A3B8"),
        accent: Color(hex: "#03DAC6"),
        destructive: Color(hex: "#FF4A9E")
      )

    case .electricDream:
      return ThemeColors(
        categoryColors: [
          Color(hex: "#38BFFF"),
          Color(hex: "#E879F9"),
          Color(hex: "#9F7AEA"),
          Color(hex: "#22D3EE"),
          Color(hex: "#22D3EE"),
          Color(hex: "#C084FC"),
          Color(hex: "#F472B6"),
          Color(hex: "#60A5FA"),
          Color(hex: "#A78BFA"),
          Color(hex: "#2DD4BF"),
        ],
        primaryBackground: Color(hex: "#0F0A1E"),
        secondaryBackground: Color(hex: "#1E1533"),
        primaryText: Color(hex: "#EEF2FF"),
        secondaryText: Color(hex: "#A5B4FC"),
        accent: Color(hex: "#38BFFF"),
        destructive: Color(hex: "#E879F9")
      )
    }
  }
}

struct ThemeColors {
  let categoryColors: [Color]
  let primaryBackground: Color
  let secondaryBackground: Color
  let primaryText: Color
  let secondaryText: Color
  let accent: Color
  let destructive: Color

  func categoryColor(at index: Int) -> Color {
    guard index >= 0 && index < categoryColors.count else {
      return categoryColors[0]
    }
    return categoryColors[index]
  }
}
