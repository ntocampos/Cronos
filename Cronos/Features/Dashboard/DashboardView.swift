//
//  DashboardView.swift
//  Cronos
//
//  Created by Assistant on 11/10/25.
//

import SwiftData
import SwiftUI

struct DashboardView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \Deadline.date, order: .forward) private var deadlines: [Deadline]
  @State private var showingAddDeadline = false
  @State private var deadlineToEdit: Deadline?

  var body: some View {
    NavigationView {
      List {
        ForEach(deadlines) { deadline in
          DeadlineBarView(deadline: deadline)
            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
            .listRowBackground(Color.clear)
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
              Button(action: {
                deadlineToEdit = deadline
              }) {
                Label("Edit", systemImage: "pencil")
              }
              .tint(.blue)

              Button(
                role: .destructive,
                action: {
                  deleteDeadline(deadline)
                }
              ) {
                Label("Delete", systemImage: "trash")
              }
            }
        }
      }
      .listStyle(.plain)
      .navigationTitle("Dashboard")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: { showingAddDeadline = true }) {
            Label("Add Deadline", systemImage: "plus")
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
        if deadlines.isEmpty {
          ContentUnavailableView(
            "No Deadlines",
            systemImage: "calendar",
            description: Text("Add your first deadline to get started")
          )
        }
      }
    }
  }

  private func deleteDeadline(_ deadline: Deadline) {
    withAnimation {
      modelContext.delete(deadline)
    }
  }
}

#Preview {
  NavigationView {
    DashboardView()
  }
  .modelContainer(for: [Deadline.self, Category.self], inMemory: true)
}
