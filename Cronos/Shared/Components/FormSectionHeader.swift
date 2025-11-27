import SwiftUI

struct FormSectionHeader: View {
  let title: String
  let icon: String?

  init(_ title: String, icon: String? = nil) {
    self.title = title
    self.icon = icon
  }

  var body: some View {
    HStack(spacing: 6) {
      if let icon {
        Image(systemName: icon)
          .font(.subheadline)
          .foregroundStyle(.secondary)
      }

      Text(title)
        .font(.subheadline)
        .fontWeight(.medium)
        .foregroundStyle(.secondary)
    }
  }
}

#Preview {
  VStack(alignment: .leading, spacing: 16) {
    FormSectionHeader("Category")
    FormSectionHeader("Due Date", icon: "calendar")
    FormSectionHeader("Information", icon: "info.circle")
  }
  .padding()
}
