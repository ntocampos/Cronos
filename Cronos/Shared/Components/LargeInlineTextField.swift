import SwiftUI

struct LargeInlineTextField: View {
  @Binding var text: String
  let placeholder: String
  var isFocused: FocusState<Bool>.Binding

  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  var body: some View {
    ZStack(alignment: .topLeading) {
      // Placeholder text - fades as user types
      if text.isEmpty {
        Text(placeholder)
          .font(.system(size: 34, weight: .bold))
          .foregroundStyle(.tertiary)
          .allowsHitTesting(false)
      }

      // Actual text field
      TextField("", text: $text, axis: .vertical)
        .font(.system(size: 34, weight: .bold))
        .focused(isFocused)
        .lineLimit(1...3)
        .submitLabel(.done)
    }
    .animation(reduceMotion ? nil : .contentTransition, value: text.isEmpty)
    .accessibilityLabel(text.isEmpty ? placeholder : "Title: \(text)")
    .accessibilityHint("Double tap to edit")
  }
}

#Preview {
  struct PreviewWrapper: View {
    @State private var text = ""
    @FocusState private var isFocused: Bool

    var body: some View {
      VStack(spacing: 32) {
        LargeInlineTextField(
          text: $text,
          placeholder: "What's the deadline?",
          isFocused: $isFocused
        )

        Button("Toggle Focus") {
          isFocused.toggle()
        }
      }
      .padding()
    }
  }

  return PreviewWrapper()
}
