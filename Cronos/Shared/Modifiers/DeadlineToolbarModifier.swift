//
//  DeadlineToolbarModifier.swift
//  Cronos
//
//  Created by Moisés Neto on 16/11/25.
//

import SwiftUI

struct DeadlineToolbarModifier: ViewModifier {
  @State private var showingAddDeadline: Bool = false

  @AppStorage(
    SettingsKeys.deadlineDensity
  ) private var deadlineDensity: DeadlineDensity = .detailed

  func body(content: Content) -> some View {
    content
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Menu {
            Section("Group by") {
              Button("Category", systemImage: "tag") {
                print("Selected grouping: Category")
              }
              Button("Timeframe", systemImage: "calendar") {
                print("Selected grouping: Timeframe")
              }
            }
          } label: {
            Label("Group by", systemImage: "rectangle.3.group")
          }
        }

        ToolbarItem(placement: .topBarTrailing) {
          Button {
            deadlineDensity = deadlineDensity == .detailed ? .compact : .detailed
          } label: {
            Label(
              deadlineDensity == .detailed ? "Compact" : "Detailed",
              systemImage: deadlineDensity == .detailed
                ? "rectangle.compress.vertical" : "rectangle.expand.vertical"
            )
          }
        }

        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Add Deadline", systemImage: "plus") {
            showingAddDeadline = true
          }
          .buttonStyle(.glassProminent)
        }
      }
      .sheet(isPresented: $showingAddDeadline) {
        DeadlineFormView()
          .presentationDetents([.large])
          .presentationDragIndicator(.visible)
      }
  }
}

extension View {
  func deadlineToolbar() -> some View {
    modifier(DeadlineToolbarModifier())
  }
}
