//
//  DeadlineCoordinator.swift
//  Cronos
//
//  Created by Assistant on 11/20/25.
//

import SwiftData
import SwiftUI

@MainActor
@Observable
class DeadlineCoordinator {
  var deadlineToEdit: Deadline?

  func edit(_ deadline: Deadline) {
    deadlineToEdit = deadline
  }

  func delete(_ deadline: Deadline, context: ModelContext) {
    withAnimation {
      context.delete(deadline)
    }
  }

  func clearEditState() {
    deadlineToEdit = nil
  }
}
