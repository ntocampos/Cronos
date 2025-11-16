//
//  DataContainer.swift
//  Cronos
//
//  Created by Moisés Neto on 16/11/25.
//

import SwiftData
import SwiftUI

@Observable
@MainActor
class DataContainer {
  let modelContainer: ModelContainer

  var context: ModelContext {
    modelContainer.mainContext
  }

  init(includeSampleMoments: Bool = false, isStoredInMemoryOnly: Bool = false) {
    let schema = Schema([
      Category.self,
      Deadline.self,
    ])

    let modelConfiguration = ModelConfiguration(
      schema: schema,
      isStoredInMemoryOnly: isStoredInMemoryOnly
    )

    do {
      modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])

      if includeSampleMoments {
        loadSampleData()
      }

      try context.save()
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }

  private func loadSampleData() {
    for category in Category.sampleData {
      context.insert(category)
    }

    for deadline in Deadline.sampleData {
      context.insert(deadline)
    }
  }
}

let sampleContainer = DataContainer(includeSampleMoments: true, isStoredInMemoryOnly: true)
let emptyContainer = DataContainer(isStoredInMemoryOnly: true)

extension View {
  func sampleDataContainer() -> some View {
    self
      .environment(sampleContainer)
      .modelContainer(sampleContainer.modelContainer)
  }

  func emptyDataContainer() -> some View {
    self.environment(emptyContainer)
      .modelContainer(emptyContainer.modelContainer)
  }
}
