//
//  DefaultColors.swift
//  Cronos
//
//  Created by Moisés Neto on 11/10/25.
//

import SwiftUI

extension Category {
  /// Returns a SwiftUI Color from the stored HEX string
  var color: Color {
    Color(hex: colorHex)
  }

  /// Updates the category color from a SwiftUI Color
  func setColor(_ color: Color) {
    self.colorHex = color.toHex()
  }

  /// Predefined category colors as HEX strings
  enum DefaultColors {
    static let blue = "#007AFF"
    static let red = "#FF3B30"
    static let green = "#34C759"
    static let orange = "#FF9500"
    static let yellow = "#FFCC00"
    static let purple = "#AF52DE"
    static let pink = "#FF2D92"
    static let teal = "#5AC8FA"
    static let indigo = "#5856D6"
    static let mint = "#00C7BE"

    static let all = [
      blue, red, green, orange, yellow, purple, pink, teal, indigo, mint,
    ]
  }
}
