import SwiftUI

struct ColorPillSelector: View {
  let colors: [String]  // HEX strings
  @Binding var selectedColorHex: String

  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  private let columns = [
    GridItem(.adaptive(minimum: 50, maximum: 60), spacing: 12)
  ]

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      FormSectionHeader("Color", icon: "paintpalette")

      LazyVGrid(columns: columns, spacing: 12) {
        ForEach(colors, id: \.self) { colorHex in
          ColorPill(
            colorHex: colorHex,
            isSelected: selectedColorHex == colorHex,
            reduceMotion: reduceMotion,
            onTap: {
              withAnimation(reduceMotion ? nil : .formBouncy) {
                selectedColorHex = colorHex
              }
            }
          )
        }
      }
    }
  }
}

private struct ColorPill: View {
  let colorHex: String
  let isSelected: Bool
  let reduceMotion: Bool
  let onTap: () -> Void

  private var color: Color {
    Color(hex: colorHex)
  }

  var body: some View {
    Button(action: onTap) {
      Circle()
        .fill(color)
        .frame(width: 44, height: 44)
        .overlay(
          Circle()
            .strokeBorder(
              isSelected ? Color.primary : Color.clear,
              lineWidth: 3
            )
        )
        .overlay(
          Circle()
            .strokeBorder(
              Color.white.opacity(0.3),
              lineWidth: 1
            )
        )
        .shadow(
          color: isSelected ? color.opacity(0.5) : .clear,
          radius: isSelected ? 8 : 0
        )
        .scaleEffect(isSelected ? 1.1 : 1.0)
    }
    .buttonStyle(.plain)
    .animation(reduceMotion ? nil : .formBouncy, value: isSelected)
    .accessibilityLabel("Color")
    .accessibilityValue(colorName(for: colorHex))
    .accessibilityHint(isSelected ? "Selected" : "Double tap to select")
    .accessibilityAddTraits(isSelected ? .isSelected : [])
  }

  private func colorName(for hex: String) -> String {
    // Map hex values to human-readable names
    switch hex.lowercased() {
    case "#007aff": return "Blue"
    case "#ff3b30": return "Red"
    case "#34c759": return "Green"
    case "#ff9500": return "Orange"
    case "#ffcc00": return "Yellow"
    case "#af52de": return "Purple"
    case "#ff2d92": return "Pink"
    case "#5ac8fa": return "Teal"
    case "#5856d6": return "Indigo"
    case "#00c7be": return "Mint"
    default: return "Custom color"
    }
  }
}

#Preview {
  struct PreviewWrapper: View {
    @State private var selectedColor = Category.DefaultColors.blue

    var body: some View {
      VStack {
        ColorPillSelector(
          colors: Category.DefaultColors.all,
          selectedColorHex: $selectedColor
        )
        .padding()

        Spacer()

        Circle()
          .fill(Color(hex: selectedColor))
          .frame(width: 60, height: 60)
          .padding()
      }
      .background(Color(.systemGroupedBackground))
    }
  }

  return PreviewWrapper()
}
