import SwiftUI

struct ThemePickerView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.colorScheme) private var systemColorScheme
  @EnvironmentObject private var themeManager: ThemeManager

  var body: some View {
    NavigationView {
      ScrollView {
        VStack(spacing: 20) {
          VStack(alignment: .leading, spacing: 12) {
            Text("Choose Your Theme")
              .font(.title2)
              .fontWeight(.bold)

            Text(
              "Select a color theme for the app. The theme will adapt to your system's light or dark mode setting."
            )
            .font(.subheadline)
            .foregroundColor(.secondary)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.horizontal)
          .padding(.top, 8)

          ForEach(Theme.allCases) { theme in
            ThemePreviewCard(
              theme: theme,
              colorScheme: systemColorScheme,
              isSelected: themeManager.currentTheme == theme,
              action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                  themeManager.setTheme(theme)
                }
              }
            )
            .padding(.horizontal)
          }

          Button(action: {
            withAnimation {
              themeManager.setTheme(.classic)
            }
          }) {
            HStack {
              Image(systemName: "arrow.clockwise")
              Text("Reset to Classic")
            }
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(.secondary)
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(
              Capsule()
                .fill(Color(.secondarySystemFill))
            )
          }
          .buttonStyle(.plain)
          .padding(.top, 8)
          .padding(.bottom, 20)
        }
      }
      .navigationTitle("Theme")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Done") {
            dismiss()
          }
        }
      }
    }
  }
}

#Preview {
  ThemePickerView()
    .environmentObject(ThemeManager())
}
