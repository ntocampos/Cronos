import SwiftUI

extension Animation {
  /// Standard bouncy animation for interactive elements (selection, taps)
  static let formBouncy = Animation.bouncy(duration: 0.3)

  /// Quick transition for focus states (border, glow)
  static let focusTransition = Animation.easeInOut(duration: 0.25)

  /// Smooth transition for content changes (placeholder fade, state changes)
  static let contentTransition = Animation.easeInOut(duration: 0.2)
}
