//
//  Color.swift
//  Cronos
//
//  Created by Moisés Neto on 11/10/25.
//

import SwiftUI

extension Color {
  /// Initialize Color from HEX string
  init(hex: String) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&int)
    let a: UInt64
    let r: UInt64
    let g: UInt64
    let b: UInt64
    switch hex.count {
    case 3:  // RGB (12-bit)
      (a, r, g, b) = (
        255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17
      )
    case 6:  // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8:  // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (1, 1, 1, 0)
    }

    self.init(
      .sRGB,
      red: Double(r) / 255,
      green: Double(g) / 255,
      blue: Double(b) / 255,
      opacity: Double(a) / 255
    )
  }

  /// Convert Color to HEX string
  func toHex() -> String {
    guard let components = cgColor?.components, components.count >= 3 else {
      return "#000000"
    }

    let r = Float(components[0])
    let g = Float(components[1])
    let b = Float(components[2])

    return String(
      format: "#%02lX%02lX%02lX",
      lroundf(r * 255),
      lroundf(g * 255),
      lroundf(b * 255)
    )
  }
}

#if canImport(UIKit)
  import UIKit

  extension Category {
    /// Returns a UIColor from the stored HEX string
    var uiColor: UIColor {
      UIColor(hex: colorHex)
    }
  }

  extension UIColor {
    /// Initialize UIColor from HEX string
    convenience init(hex: String) {
      let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
      var int: UInt64 = 0
      Scanner(string: hex).scanHexInt64(&int)
      let a: UInt64
      let r: UInt64
      let g: UInt64
      let b: UInt64
      switch hex.count {
      case 3:  // RGB (12-bit)
        (a, r, g, b) = (
          255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17
        )
      case 6:  // RGB (24-bit)
        (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
      case 8:  // ARGB (32-bit)
        (a, r, g, b) = (
          int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF
        )
      default:
        (a, r, g, b) = (255, 0, 0, 0)
      }

      self.init(
        red: CGFloat(r) / 255,
        green: CGFloat(g) / 255,
        blue: CGFloat(b) / 255,
        alpha: CGFloat(a) / 255
      )
    }
  }
#endif

#if canImport(AppKit)
  import AppKit
  import SwiftUI

  extension Category {
    /// Returns an NSColor from the stored HEX string
    var nsColor: NSColor {
      NSColor(hex: colorHex)
    }
  }

  extension NSColor {
    /// Initialize NSColor from HEX string
    convenience init(hex: String) {
      let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
      var int: UInt64 = 0
      Scanner(string: hex).scanHexInt64(&int)
      let a: UInt64
      let r: UInt64
      let g: UInt64
      let b: UInt64
      switch hex.count {
      case 3:  // RGB (12-bit)
        (a, r, g, b) = (
          255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17
        )
      case 6:  // RGB (24-bit)
        (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
      case 8:  // ARGB (32-bit)
        (a, r, g, b) = (
          int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF
        )
      default:
        (a, r, g, b) = (255, 0, 0, 0)
      }

      self.init(
        red: CGFloat(r) / 255,
        green: CGFloat(g) / 255,
        blue: CGFloat(b) / 255,
        alpha: CGFloat(a) / 255
      )
    }
  }
#endif
