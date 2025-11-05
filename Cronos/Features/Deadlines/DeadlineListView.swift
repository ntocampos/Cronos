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

  init(
    deadlines: [Deadline],
    onEdit: @escaping (Deadline) -> Void,
    onDelete: @escaping (Deadline) -> Void,
  ) {
    self.deadlines = deadlines
    self.onEdit = onEdit
    self.onDelete = onDelete
  }

  var body: some View {
    List {
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
}

#Preview {
  let sampleDeadlines = SampleData.getDeadlines()

  DeadlineListView(
    deadlines: Array(sampleDeadlines.prefix(2)),
    onEdit: { _ in print("Edit tapped") },
    onDelete: { _ in print("Delete tapped") }
  )

  DeadlineListView(
    deadlines: Array(sampleDeadlines.suffix(2)),
    onEdit: { _ in print("Edit tapped") },
    onDelete: { _ in print("Delete tapped") },
  )
}
