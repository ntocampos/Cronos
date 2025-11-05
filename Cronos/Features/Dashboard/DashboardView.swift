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
    NavigationStack {
      ZStack {
        AnimatedBlobGradientView()
          .ignoresSafeArea()

        DeadlineListView(
          deadlines: deadlines,
          onEdit: editDeadline,
          onDelete: deleteDeadline
        )
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
      }
      .navigationTitle("Dashboard")
      .navigationBarTitleDisplayMode(.large)
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

  private func editDeadline(_ deadline: Deadline) {
    deadlineToEdit = deadline
  }

  private func deleteDeadline(_ deadline: Deadline) {
    withAnimation {
      modelContext.delete(deadline)
    }
  }

}

#Preview {
  DashboardView()
    .modelContainer(.preview)
}
