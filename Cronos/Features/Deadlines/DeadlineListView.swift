//
//  DeadlineListView.swift
//  Cronos
//
//  Created by Assistant on 11/10/25.
//

import SwiftData
import SwiftUI

struct DeadlineListView: View {
  let deadlines: [Deadline]
  let categories: [Category]
  let allDeadlinesCount: Int
  @Binding var selectedCategory: Category?
  let onEdit: (Deadline) -> Void
  let onDelete: (Deadline) -> Void

  init(
    deadlines: [Deadline],
    categories: [Category],
    allDeadlinesCount: Int,
    selectedCategory: Binding<Category?>,
    onEdit: @escaping (Deadline) -> Void,
    onDelete: @escaping (Deadline) -> Void
  ) {
    self.deadlines = deadlines
    self.categories = categories
    self.allDeadlinesCount = allDeadlinesCount
    self._selectedCategory = selectedCategory
    self.onEdit = onEdit
    self.onDelete = onDelete
  }

  var body: some View {
    List {
      CategoryFilterRow(
        categories: categories,
        allDeadlinesCount: allDeadlinesCount,
        selectedCategory: $selectedCategory
      )

      if let selectedCategory {
        FilterNoticeView(
          categoryName: selectedCategory.name,
          categoryColor: selectedCategory.color
        )
      }

      ForEach(deadlines) { deadline in
        DeadlineBarView(deadline: deadline)
          .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
          .listRowBackground(Color.clear)
          .listRowSeparator(.hidden)
          .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(action: {
              onEdit(deadline)
            }) {
              Image(systemName: "pencil")
            }
            .tint(.blue)

            Button(
              role: .destructive,
              action: {
                onDelete(deadline)
              }
            ) {
              Image(systemName: "trash")
            }
          }
      }
    }
    .animation(.default, value: selectedCategory)
  }
}

#Preview {
  @Previewable @State var selectedCategory: Category? = nil

  let container = ModelContainer.preview
  let context = container.mainContext

  let categories = try! context.fetch(FetchDescriptor<Category>())
  let deadlines = try! context.fetch(FetchDescriptor<Deadline>())

  return DeadlineListView(
    deadlines: deadlines,
    categories: categories,
    allDeadlinesCount: deadlines.count,
    selectedCategory: $selectedCategory,
    onEdit: { _ in print("Edit tapped") },
    onDelete: { _ in print("Delete tapped") }
  )
  .listStyle(.plain)
  .modelContainer(container)
}
