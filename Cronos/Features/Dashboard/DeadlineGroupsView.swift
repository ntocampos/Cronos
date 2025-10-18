//
//  DeadlineGroups.swift
//  Cronos
//
//  Created by Moisés Neto on 18/10/25.
//

import Foundation
import SwiftData
import SwiftUI

enum DeadlineGroup {
  case all
  case byCategory
  case byTimeframe
}

struct DeadlineGroupsView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \Deadline.date, order: .forward) private var deadlines: [Deadline]

  @State private var selectedGroup: DeadlineGroup = .all
  @State private var deadlineToEdit: Deadline? = nil

  var body: some View {
    VStack {
      filter

      DeadlineListView(
        deadlines: deadlines,
        onEdit: editDeadline,
        onDelete: deleteDeadline
      )
    }
    .sheet(item: $deadlineToEdit) { deadline in
      DeadlineFormView(deadline: deadline)
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
  }

  private var filter: some View {
    Picker("Group by", selection: $selectedGroup) {
      Text("All").tag(DeadlineGroup.all)
      Text("By Category").tag(DeadlineGroup.byCategory)
      Text("By Timeframe").tag(DeadlineGroup.byTimeframe)
    }
    .pickerStyle(.segmented)
    .padding()
  }

  private func editDeadline(_ deadline: Deadline) {
    self.deadlineToEdit = deadline
  }

  private func deleteDeadline(_ deadline: Deadline) {
    withAnimation {
      modelContext.delete(deadline)
    }
  }
}

#Preview {
  let container = try! ModelContainer(
    for: Deadline.self,
    Category.self,
    configurations: ModelConfiguration(isStoredInMemoryOnly: true)
  )

  // Create sample data immediately in the preview
  let context = container.mainContext

  // Create some sample categories
  let workCategory = Category(
    name: "Work",
    colorHex: Category.DefaultColors.blue
  )
  let personalCategory = Category(
    name: "Personal",
    colorHex: Category.DefaultColors.green
  )
  let studyCategory = Category(
    name: "Study",
    colorHex: Category.DefaultColors.orange
  )

  // Insert categories into the context
  context.insert(workCategory)
  context.insert(personalCategory)
  context.insert(studyCategory)

  // Create sample deadlines
  let sampleDeadlines = [
    Deadline(
      title: "Project Presentation",
      notes: "Final presentation for Q4 project",
      date: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(),
      category: workCategory
    ),
    Deadline(
      title: "Tax Filing",
      notes: "Submit annual tax return",
      date: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date(),
      category: personalCategory
    ),
    Deadline(
      title: "Assignment Due",
      notes: "SwiftUI advanced concepts essay",
      date: Calendar.current.date(byAdding: .day, value: 14, to: Date()) ?? Date(),
      category: studyCategory
    ),
    Deadline(
      title: "Doctor Appointment",
      notes: "Annual checkup",
      date: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(),
      category: personalCategory
    ),
  ]

  // Insert deadlines into the context
  for deadline in sampleDeadlines {
    context.insert(deadline)
  }

  return DeadlineGroupsView()
    .modelContainer(container)
}
