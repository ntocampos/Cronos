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
              .padding(.horizontal, 16)
              .onTapGesture {
                coordinator.edit(deadline)
              }
              .contextMenu {
                Button("Edit", systemImage: "square.and.pencil") {
                  coordinator.edit(deadline)
                }
                Button("Delete", systemImage: "trash", role: .destructive) {
                  coordinator.delete(deadline, context: modelContext)
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
  @Previewable @State var coordinator = DeadlineCoordinator()

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
    selectedCategory: $selectedCategory
  )
  .modelContainer(dataContainer.modelContainer)
  .environment(coordinator)
}
