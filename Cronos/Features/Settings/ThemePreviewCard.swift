import SwiftUI

struct ThemePreviewCard: View {
  let theme: Theme
  let colorScheme: ColorScheme
  let isSelected: Bool
  let action: () -> Void

  private var themeColors: ThemeColors {
    theme.colors(for: colorScheme)
  }

  var body: some View {
    Button(action: action) {
      VStack(alignment: .leading, spacing: 12) {
        HStack {
          Text(theme.name)
            .font(.headline)
            .foregroundColor(themeColors.primaryText)

          Spacer()

          if isSelected {
            Image(systemName: "checkmark.circle.fill")
              .foregroundColor(themeColors.accent)
              .font(.title3)
          }
        }

        Text(theme.description)
          .font(.caption)
          .foregroundColor(themeColors.secondaryText)
          .lineLimit(2)
          .multilineTextAlignment(.leading)

        VStack(spacing: 8) {
          MiniDeadlineBar(
            title: "Project Deadline",
            colorIndex: 0,
            width: 0.85,
            themeColors: themeColors
          )

          MiniDeadlineBar(
            title: "Team Meeting",
            colorIndex: 2,
            width: 0.50,
            themeColors: themeColors
          )

          MiniDeadlineBar(
            title: "Client Presentation",
            colorIndex: 1,
            width: 1.0,
            themeColors: themeColors
          )
        }

        HStack(spacing: 4) {
          ForEach(0..<5, id: \.self) { index in
            Circle()
              .fill(themeColors.categoryColor(at: index))
              .frame(width: 20, height: 20)
          }
        }
      }
      .padding(16)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(
        RoundedRectangle(cornerRadius: 16)
          .fill(themeColors.primaryBackground)
          .shadow(
            color: themeColors.primaryText.opacity(0.1),
            radius: 8,
            x: 0,
            y: 2
          )
      )
      .overlay(
        RoundedRectangle(cornerRadius: 16)
          .strokeBorder(
            isSelected ? themeColors.accent : Color.clear,
            lineWidth: 2
          )
      )
    }
    .buttonStyle(.plain)
  }
}

private struct MiniDeadlineBar: View {
  let title: String
  let colorIndex: Int
  let width: Double
  let themeColors: ThemeColors

  var body: some View {
    ZStack(alignment: .leading) {
      RoundedRectangle(cornerRadius: 8)
        .fill(themeColors.secondaryBackground.opacity(0.3))
        .frame(height: 36)

      GeometryReader { geometry in
        HStack {
          Spacer(minLength: 0)
          RoundedRectangle(cornerRadius: 6)
            .fill(themeColors.categoryColor(at: colorIndex).opacity(0.3))
            .frame(width: geometry.size.width * width)
            .padding(2)
        }
      }
      .frame(height: 36)

      HStack {
        Text(title)
          .font(.caption)
          .fontWeight(.medium)
          .foregroundColor(themeColors.primaryText)
          .lineLimit(1)
          .padding(.leading, 8)

        Spacer()

        Image(systemName: "chevron.right")
          .font(.caption2)
          .foregroundColor(themeColors.categoryColor(at: colorIndex))
          .padding(.trailing, 8)
      }
      .frame(height: 36)
    }
  }
}

#Preview("Light Mode") {
  ScrollView {
    VStack(spacing: 16) {
      ForEach(Theme.allCases) { theme in
        ThemePreviewCard(
          theme: theme,
          colorScheme: .light,
          isSelected: theme == .classic,
          action: { print("Selected \(theme.name)") }
        )
      }
    }
    .padding()
  }
  .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
  ScrollView {
    VStack(spacing: 16) {
      ForEach(Theme.allCases) { theme in
        ThemePreviewCard(
          theme: theme,
          colorScheme: .dark,
          isSelected: theme == .pastelDream,
          action: { print("Selected \(theme.name)") }
        )
      }
    }
    .padding()
  }
  .preferredColorScheme(.dark)
  .background(Color.black)
}
