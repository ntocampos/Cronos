//
//  DeadlineToolbarModifier.swift
//  Cronos
//
//  Created by Moisés Neto on 16/11/25.
//

import SwiftUI

struct DeadlineToolbarModifier: ViewModifier {
  @Binding var selectedGroupingMode: GroupingMode
  @Binding var selectedFilterMode: DeadlineFilterMode
  @State private var showingAddDeadline: Bool = false

  @AppStorage(
    SettingsKeys.deadlineDensity
  ) private var deadlineDensity: DeadlineDensity = .detailed

  private var groupingIcon: String {
    switch selectedGroupingMode {
    case .none: return "rectangle.3.group"
    case .byCategory: return "tag.circle.fill"
    case .byTimeframe: return "calendar.circle.fill"
    }
  }

  private var isGroupingActive: Bool {
    selectedGroupingMode != .none
  }

  private var filterIcon: String {
    switch selectedFilterMode {
    case .active: return "circle"
    case .completed: return "checkmark.circle.fill"
    }
  }

  func body(content: Content) -> some View {
    content
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Menu {
            Section("Filter") {
              Button("Active", systemImage: "circle") {
                selectedFilterMode = .active
              }
              Button("Completed", systemImage: "checkmark.circle") {
                selectedFilterMode = .completed
              }
            }
          } label: {
            Label("Filter", systemImage: filterIcon)
              .foregroundStyle(
                selectedFilterMode == .completed ? Color.accentColor : Color.primary
              )
          }
        }

        ToolbarItem(placement: .topBarTrailing) {
          Menu {
            Section("Group by") {
              Button("None", systemImage: "list.bullet") {
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

        ToolbarItem(placement: .topBarLeading) {
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
  func deadlineToolbar(
    groupingMode: Binding<GroupingMode>,
    filterMode: Binding<DeadlineFilterMode>
  ) -> some View {
    modifier(
      DeadlineToolbarModifier(
        selectedGroupingMode: groupingMode,
        selectedFilterMode: filterMode
      ))
  }
}
