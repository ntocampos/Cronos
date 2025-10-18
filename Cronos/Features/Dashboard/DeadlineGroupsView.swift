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
  DeadlineGroupsView()
    .modelContainer(.preview)
}
