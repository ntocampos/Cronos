//
//  DashboardView.swift
//  Cronos
//
//  Created by Assistant on 11/10/25.
//

import SwiftData
import SwiftUI

struct DashboardView: View {
  @Environment(DataContainer.self) private var dataContainer
  @Environment(DeadlineCoordinator.self) private var coordinator
  @Query(sort: \Deadline.date, order: .forward) private var deadlines: [Deadline]
  @Query(sort: \Category.sortOrder, order: .forward) private var categories: [Category]

  @State private var showingAddDeadline = false
  @State private var selectedCategory: Category?

  @AppStorage(SettingsKeys.deadlineDensity) private var deadlineDensity: DeadlineDensity = .detailed

  private var filteredDeadlines: [Deadline] {
    guard let selectedCategory else { return deadlines }
    return deadlines.filter { $0.category?.id == selectedCategory.id }
  }

  var body: some View {
    @Bindable var coordinator = coordinator

    NavigationStack {
      ZStack {
        DeadlineListView(
          deadlines: filteredDeadlines,
          categories: categories,
          allDeadlinesCount: deadlines.count,
          selectedCategory: $selectedCategory
        )
      }
      .navigationTitle("Overview")
      .navigationBarTitleDisplayMode(.large)
      .deadlineToolbar()
      .sheet(item: $coordinator.deadlineToEdit) { deadline in
        DeadlineFormView(deadline: deadline)
          .presentationDetents([.large])
          .presentationDragIndicator(.visible)
      }
      .overlay {
        if filteredDeadlines.isEmpty && selectedCategory == nil {
          ContentUnavailableView(
            "No Deadlines",
            systemImage: "calendar",
            description: Text("Add your first deadline to get started")
          )
        } else if filteredDeadlines.isEmpty && selectedCategory != nil {
          ContentUnavailableView(
            "No Items in This Category",
            systemImage: "tray",
            description: Text(
              "Try selecting a different category or add a new deadline"
            )
          )
        }
      }
    }
  }
}

#Preview {
  @Previewable @State var coordinator = DeadlineCoordinator()

  DashboardView()
    .sampleDataContainer()
    .environment(coordinator)
}
