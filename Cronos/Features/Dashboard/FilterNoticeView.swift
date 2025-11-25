import SwiftUI

struct FilterNoticeView: View {
  let categoryName: String
  let categoryColor: Color
  let onClear: () -> Void

  var body: some View {
    HStack(spacing: 6) {
      Image(systemName: "line.3.horizontal.decrease.circle.fill")
        .font(.subheadline)
        .foregroundColor(categoryColor)

      Text("Showing items for")
        .font(.subheadline)
        .foregroundColor(.secondary)

      Text(categoryName)
        .font(.subheadline)
        .fontWeight(.semibold)
        .foregroundColor(categoryColor)

      Spacer()

      Button("Clear", action: onClear)
        .font(.subheadline)
        .fontWeight(.medium)
        .foregroundColor(categoryColor)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 16)
    .padding(.vertical, 12)
    .background(
      RoundedRectangle(cornerRadius: 12)
        .fill(categoryColor.opacity(0.1))
    )
    .padding(.horizontal, 16)
    .listRowInsets(EdgeInsets())
    .listRowBackground(Color.clear)
    .listRowSeparator(.hidden)
  }
}

#Preview {
  List {
    FilterNoticeView(
      categoryName: "Work",
      categoryColor: .blue
    ) {}

    FilterNoticeView(
      categoryName: "Personal",
      categoryColor: .green
    ) {}

    FilterNoticeView(
      categoryName: "School",
      categoryColor: .orange
    ) {}
  }
  .listStyle(.plain)
}
