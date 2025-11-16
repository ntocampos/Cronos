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

  @AppStorage(SettingsKeys.deadlineDensity) private var deadlineDensity: DeadlineDensity = .detailed

  var body: some View {
    ScrollView {
      VStack(spacing: 0) {
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

        LazyVStack(spacing: 12) {
          ForEach(deadlines) { deadline in
            DeadlineBarView(deadline: deadline)
              .padding(.horizontal, 16)
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
        .padding(.vertical, 6)
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
  .modelContainer(dataContainer.modelContainer)
}
