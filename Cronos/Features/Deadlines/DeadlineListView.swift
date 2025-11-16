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
          .listRowInsets(
            EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16)
          )
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

  let dataContainer = DataContainer(
    includeSampleMoments: true,
    isStoredInMemoryOnly: true
  )

  let categories = try! dataContainer.context.fetch(FetchDescriptor<Category>())
  let deadlines = try! dataContainer.context.fetch(FetchDescriptor<Deadline>())

  DeadlineListView(
    deadlines: deadlines,
    categories: categories,
    allDeadlinesCount: deadlines.count,
    selectedCategory: $selectedCategory,
    onEdit: { _ in print("Edit tapped") },
    onDelete: { _ in print("Delete tapped") }
  )
  .listStyle(.plain)
  .modelContainer(dataContainer.modelContainer)
}
