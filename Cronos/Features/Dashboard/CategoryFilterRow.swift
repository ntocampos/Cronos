import SwiftData
import SwiftUI

struct CategoryFilterRow: View {
  let categories: [Category]
  let allDeadlinesCount: Int
  let categoryDeadlineCounts: [UUID: Int]
  @Binding var selectedCategory: Category?

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 12) {
        CategoryButton(
          name: "All",
          color: .gray,
          count: allDeadlinesCount,
          isSelected: selectedCategory == nil,
          action: { selectedCategory = nil }
        )

        ForEach(categories) { category in
          CategoryButton(
            name: category.name,
            color: category.color,
            count: categoryDeadlineCounts[category.id] ?? 0,
            isSelected: selectedCategory?.id == category.id,
            action: { selectedCategory = category }
          )
        }
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 12)
    }
    .listRowInsets(EdgeInsets())
    .listRowBackground(Color.clear)
    .listRowSeparator(.hidden)
  }
}

private struct CategoryButton: View {
  let name: String
  let color: Color
  let count: Int
  let isSelected: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      HStack(spacing: 6) {
        Text(name)
          .font(.subheadline)
          .fontWeight(.medium)

        Text("(\(count))")
          .font(.caption)
          .fontWeight(.semibold)
      }
      .foregroundColor(isSelected ? .white : color)
      .padding(.horizontal, 14)
      .padding(.vertical, 8)
      .background(
        ZStack {
          if isSelected {
            Capsule()
              .fill(color)
              .glassEffect(in: .capsule)
          } else {
            Capsule()
              .fill(Color(.secondarySystemFill).opacity(0.3))
              .glassEffect(in: .capsule)
              .overlay(
                Capsule()
                  .strokeBorder(color.opacity(0.5), lineWidth: 1.5)
              )
          }
        }
      )
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  @Previewable @State var selectedCategory: Category? = nil

  let dataContainer = DataContainer(includeSampleMoments: true, isStoredInMemoryOnly: true)

  let categories = try! dataContainer.context.fetch(FetchDescriptor<Category>())
  let deadlines = try! dataContainer.context.fetch(FetchDescriptor<Deadline>())

  // Build category counts dictionary using reduce
  let counts = Dictionary(
    uniqueKeysWithValues: categories.map { category in
      (category.id, deadlines.filter { $0.category.id == category.id }.count)
    }
  )

  List {
    CategoryFilterRow(
      categories: categories,
      allDeadlinesCount: deadlines.count,
      categoryDeadlineCounts: counts,
      selectedCategory: $selectedCategory
    )

    ForEach(deadlines) { deadline in
      Text(deadline.title)
    }
  }
  .listStyle(.plain)
  .modelContainer(dataContainer.modelContainer)
}
