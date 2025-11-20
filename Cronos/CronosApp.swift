//
//  CronosApp.swift
//  Cronos
//
//  Created by Moisés Neto on 11/10/25.
//

import SwiftData
import SwiftUI

@main
struct CronosApp: App {
  let dataContainer = DataContainer()
  @State private var deadlineCoordinator = DeadlineCoordinator()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(dataContainer)
        .environment(deadlineCoordinator)
    }
    .modelContainer(dataContainer.modelContainer)
  }
}
