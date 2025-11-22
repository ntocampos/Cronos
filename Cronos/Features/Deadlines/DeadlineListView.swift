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

  @Environment(DeadlineCoordinator.self) private var coordinator
  @Environment(\.modelContext) private var modelContext

  @AppStorage(
    SettingsKeys.deadlineDensity
  ) private var deadlineDensity: DeadlineDensity = .detailed

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
              .onTapGesture {
                coordinator.edit(deadline)
              }
              .contextMenu {
                Button("Complete", systemImage: "checkmark") {
                  coordinator.complete(deadline)
                }
                Button("Edit", systemImage: "square.and.pencil") {
                  coordinator.edit(deadline)
                }
                Divider()
                Button("Delete", systemImage: "trash", role: .destructive) {
                  coordinator.delete(deadline, context: modelContext)
                }
              }
          }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 16)
      }
    }
    .animation(.default, value: selectedCategory)
  }
}

#Preview {
  @Previewable @State var selectedCategory: Category? = nil
  @Previewable @State var coordinator = DeadlineCoordinator()

  let categories = try! sampleContainer.context.fetch(FetchDescriptor<Category>())
  let allDeadlines = try! sampleContainer.context.fetch(
    FetchDescriptor<Deadline>(sortBy: [SortDescriptor(\.date)])
  )

  let deadlines =
    if let selectedCategory {
      allDeadlines.filter { $0.category.id == selectedCategory.id }
    } else {
      allDeadlines
    }

  DeadlineListView(
    deadlines: deadlines,
    categories: categories,
    allDeadlinesCount: allDeadlines.count,
    selectedCategory: $selectedCategory
  )
  .sampleDataContainer()
  .environment(coordinator)
}
