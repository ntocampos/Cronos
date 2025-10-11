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
    .listStyle(.plain)
  }
}

#Preview {
  let sampleDeadlines: [Deadline] = []

  DeadlineListView(
    deadlines: sampleDeadlines,
    onEdit: { _ in },
    onDelete: { _ in }
  )
  .modelContainer(for: [Deadline.self, Category.self], inMemory: true)
}
