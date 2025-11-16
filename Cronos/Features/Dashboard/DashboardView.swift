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
  @Query(sort: \Deadline.date, order: .forward) private var deadlines: [Deadline]
  @Query(sort: \Category.sortOrder, order: .forward) private var categories: [Category]

  @State private var showingAddDeadline = false
  @State private var deadlineToEdit: Deadline?
  @State private var selectedCategory: Category?

  @AppStorage(SettingsKeys.deadlineDensity) private var deadlineDensity: DeadlineDensity = .detailed

  private var filteredDeadlines: [Deadline] {
    guard let selectedCategory else { return deadlines }
    return deadlines.filter { $0.category?.id == selectedCategory.id }
  }

  var body: some View {
    NavigationStack {
      ZStack {
        DeadlineListView(
          deadlines: filteredDeadlines,
          categories: categories,
          allDeadlinesCount: deadlines.count,
          selectedCategory: $selectedCategory,
          onEdit: editDeadline,
          onDelete: deleteDeadline
        )
      }
      .navigationTitle("Dashboard")
      .navigationBarTitleDisplayMode(.large)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            deadlineDensity = deadlineDensity == .detailed ? .compact : .detailed
          } label: {
            Label(
              deadlineDensity == .detailed ? "Collapse" : "Expand",
              systemImage: deadlineDensity == .detailed
                ? "rectangle.compress.vertical" : "rectangle.expand.vertical"
            )
          }
        }

        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Add Deadline", systemImage: "plus") {
            showingAddDeadline = true
          }
        }
      }
      .sheet(isPresented: $showingAddDeadline) {
        DeadlineFormView()
          .presentationDetents([.large])
          .presentationDragIndicator(.visible)
      }
      .sheet(item: $deadlineToEdit) { deadline in
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

  private func editDeadline(_ deadline: Deadline) {
    deadlineToEdit = deadline
  }

  private func deleteDeadline(_ deadline: Deadline) {
    withAnimation {
      dataContainer.context.delete(deadline)
    }
  }

}

#Preview {
  DashboardView()
    .sampleDataContainer()
}
