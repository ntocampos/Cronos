import SwiftUI

enum Theme: String, CaseIterable, Identifiable {
  case classic
  case pastelDream
  case monochrome
  case warmEarth
  case coolOcean

  var id: String { rawValue }

  var name: String {
    switch self {
    case .classic: return "Classic"
    case .pastelDream: return "Pastel Dream"
    case .monochrome: return "Monochrome"
    case .warmEarth: return "Warm Earth"
    case .coolOcean: return "Cool Ocean"
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
