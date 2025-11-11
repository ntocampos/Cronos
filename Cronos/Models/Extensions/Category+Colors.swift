//
//  DefaultColors.swift
//  Cronos
//
//  Created by Moisés Neto on 11/10/25.
//

import SwiftUI

extension Category {
  /// Returns the color index (0-9) for this category based on its stored hex value
  var colorIndex: Int {
    let normalizedHex = colorHex.uppercased()
    if let index = DefaultColors.classicHexValues.firstIndex(where: {
      $0.uppercased() == normalizedHex
    }) {
      return index
    }
    return 0
  }

  /// Returns a basic SwiftUI Color from the stored HEX (for legacy/service use)
  var color: Color {
    Color(hex: colorHex)
  }

  /// Returns a SwiftUI Color based on the current theme
  @MainActor
  func color(using themeManager: ThemeManager, for colorScheme: ColorScheme) -> Color {
    return themeManager.categoryColor(at: colorIndex, for: colorScheme)
  }

  /// Sets the category to use a specific theme color index (0-9)
  func setColorIndex(_ index: Int) {
    guard index >= 0 && index < DefaultColors.classicHexValues.count else { return }
    self.colorHex = DefaultColors.classicHexValues[index]
  }

  /// Predefined category colors (now using classic theme HEX values for backwards compatibility)
  enum DefaultColors {
    static let classicHexValues = [
      "#007AFF",
      "#FF3B30",
      "#34C759",
      "#FF9500",
      "#FFCC00",
      "#AF52DE",
      "#FF2D92",
      "#5AC8FA",
      "#5856D6",
      "#00C7BE",
    ]

    static let blue = classicHexValues[0]
    static let red = classicHexValues[1]
    static let green = classicHexValues[2]
    static let orange = classicHexValues[3]
    static let yellow = classicHexValues[4]
    static let purple = classicHexValues[5]
    static let pink = classicHexValues[6]
    static let teal = classicHexValues[7]
    static let indigo = classicHexValues[8]
    static let mint = classicHexValues[9]

    static let all = classicHexValues
  }
}
