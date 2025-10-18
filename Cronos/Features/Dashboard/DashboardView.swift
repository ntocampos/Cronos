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

  var body: some View {
    NavigationView {
      DeadlineGroupsView()
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

}

#Preview {
  NavigationView {
    DashboardView()
  }
  .modelContainer(for: [Deadline.self, Category.self], inMemory: true)
}
