//
//  ContentView.swift
//  Cronos
//
//  Created by Moisés Neto on 11/10/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
  var body: some View {
    DashboardView()
  }
}

#Preview {
  ContentView()
    .modelContainer(for: [Deadline.self, Category.self], inMemory: true)
}
