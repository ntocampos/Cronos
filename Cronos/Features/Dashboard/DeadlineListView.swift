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
  let onEdit: (Deadline) -> Void
  let onDelete: (Deadline) -> Void
  let sectionTitle: String?

  init(
    deadlines: [Deadline],
    onEdit: @escaping (Deadline) -> Void,
    onDelete: @escaping (Deadline) -> Void,
    sectionTitle: String? = nil
  ) {
    self.deadlines = deadlines
    self.onEdit = onEdit
    self.onDelete = onDelete
    self.sectionTitle = sectionTitle
  }

  var body: some View {
    List {
      if let sectionTitle = sectionTitle {
        Section {
          deadlinesContent
        } header: {
          Text(sectionTitle)
        }
      } else {
        deadlinesContent
      }
    }
    .listStyle(.plain)
  }

  @ViewBuilder
  private var deadlinesContent: some View {
    ForEach(deadlines) { deadline in
      DeadlineBarView(deadline: deadline)
        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
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
}

#Preview {
  @Previewable @State var container = try! ModelContainer(for: Deadline.self, Category.self)

  // Create some sample categories
  let workCategory = Category(name: "Work", colorHex: Category.DefaultColors.blue)
  let personalCategory = Category(name: "Personal", colorHex: Category.DefaultColors.green)
  let studyCategory = Category(name: "Study", colorHex: Category.DefaultColors.orange)

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
      date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
      category: personalCategory
    ),
  ]

  VStack(spacing: 20) {
    DeadlineListView(
      deadlines: Array(sampleDeadlines.prefix(2)),
      onEdit: { _ in print("Edit tapped") },
      onDelete: { _ in print("Delete tapped") }
    )
    .frame(height: 200)

    DeadlineListView(
      deadlines: Array(sampleDeadlines.suffix(2)),
      onEdit: { _ in print("Edit tapped") },
      onDelete: { _ in print("Delete tapped") },
      sectionTitle: "All Deadlines"
    )
    .frame(height: 250)
  }
  .modelContainer(container)
}
