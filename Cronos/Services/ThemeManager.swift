import Combine
import SwiftUI

@MainActor
final class ThemeManager: ObservableObject {
  private let themesKey = "selectedTheme"

  @Published var currentTheme: Theme

  init() {
    if let storedTheme = UserDefaults.standard.string(forKey: themesKey),
      let theme = Theme(rawValue: storedTheme)
    {
      self.currentTheme = theme
    } else {
      self.currentTheme = .classic
    }
  }

  func colors(for colorScheme: ColorScheme) -> ThemeColors {
    return currentTheme.colors(for: colorScheme)
  }

  func categoryColor(at index: Int, for colorScheme: ColorScheme) -> Color {
    return colors(for: colorScheme).categoryColor(at: index)
  }

  func primaryBackground(for colorScheme: ColorScheme) -> Color {
    return colors(for: colorScheme).primaryBackground
  }

  func secondaryBackground(for colorScheme: ColorScheme) -> Color {
    return colors(for: colorScheme).secondaryBackground
  }

  func primaryText(for colorScheme: ColorScheme) -> Color {
    return colors(for: colorScheme).primaryText
  }

  func secondaryText(for colorScheme: ColorScheme) -> Color {
    return colors(for: colorScheme).secondaryText
  }

  func accent(for colorScheme: ColorScheme) -> Color {
    return colors(for: colorScheme).accent
  }

  func destructive(for colorScheme: ColorScheme) -> Color {
    return colors(for: colorScheme).destructive
  }

  func setTheme(_ theme: Theme) {
    currentTheme = theme
    UserDefaults.standard.set(theme.rawValue, forKey: themesKey)
  }
}
