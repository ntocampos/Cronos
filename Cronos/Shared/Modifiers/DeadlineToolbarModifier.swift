//
//  DeadlineToolbarModifier.swift
//  Cronos
//
//  Created by Moisés Neto on 16/11/25.
//

import SwiftUI

struct DeadlineToolbarModifier: ViewModifier {
  @State private var showingAddDeadline: Bool = false
  @State private var selectedGroupingMode: GroupingMode = .none

  @AppStorage(
    SettingsKeys.deadlineDensity
  ) private var deadlineDensity: DeadlineDensity = .detailed

  private var groupingIcon: String {
    switch selectedGroupingMode {
    case .none: return "rectangle.3.group"
    case .byCategory: return "tag.fill"
    case .byTimeframe: return "calendar.circle.fill"
    }
  }

  private var isGroupingActive: Bool {
    selectedGroupingMode != .none
  }

  func body(content: Content) -> some View {
    content
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Menu {
            Section("Group by") {
              Button("None", systemImage: "rectangle.3.group") {
                selectedGroupingMode = .none
              }
              Button("Category", systemImage: "tag") {
                selectedGroupingMode = .byCategory
              }
              Button("Timeframe", systemImage: "calendar") {
                selectedGroupingMode = .byTimeframe
              }
            }
          } label: {
            Label("Group by", systemImage: groupingIcon)
              .foregroundStyle(isGroupingActive ? Color.accentColor : Color.primary)
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
