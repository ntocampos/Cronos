//
//  SettingsView.swift
//  Cronos
//
//  Created by Assistant on 11/10/25.
//

import SwiftData
import SwiftUI

struct SettingsView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.colorScheme) private var colorScheme
  @EnvironmentObject private var themeManager: ThemeManager
  @AppStorage("showNotifications") private var showNotifications = true
  @AppStorage("defaultReminderDays") private var defaultReminderDays = 3
  @State private var showingDeleteAlert = false
  @State private var showingThemePicker = false

  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Appearance")) {
          Button(action: {
            showingThemePicker = true
          }) {
            HStack {
              Image(systemName: "paintpalette")
                .foregroundColor(themeManager.accent(for: colorScheme))

              VStack(alignment: .leading, spacing: 2) {
                Text("Theme")
                  .foregroundColor(.primary)

                Text(themeManager.currentTheme.name)
                  .font(.caption)
                  .foregroundColor(.secondary)
              }

              Spacer()

              HStack(spacing: 4) {
                ForEach(0..<5, id: \.self) { index in
                  Circle()
                    .fill(themeManager.categoryColor(at: index, for: colorScheme))
                    .frame(width: 16, height: 16)
                }
              }

              Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
            }
          }
        }

        Section(header: Text("Notifications")) {
          Toggle("Enable Notifications", isOn: $showNotifications)

          if showNotifications {
            HStack {
              Text("Default Reminder")
              Spacer()
              Picker("Days", selection: $defaultReminderDays) {
                Text("1 day").tag(1)
                Text("3 days").tag(3)
                Text("1 week").tag(7)
                Text("2 weeks").tag(14)
              }
              .pickerStyle(.menu)
            }
          }
        }

        Section(header: Text("App Information")) {
          HStack {
            Text("Version")
            Spacer()
            Text("1.0.0")
              .foregroundColor(.secondary)
          }

          HStack {
            Text("Build")
            Spacer()
            Text("1")
              .foregroundColor(.secondary)
          }
        }

        Section(header: Text("Data Management")) {
          Button(action: {
            showingDeleteAlert = true
          }) {
            HStack {
              Image(systemName: "trash")
                .foregroundColor(themeManager.destructive(for: colorScheme))
              Text("Delete All Data")
                .foregroundColor(themeManager.destructive(for: colorScheme))
            }
          }
        }

        Section(header: Text("Support")) {
          Link(destination: URL(string: "mailto:support@cronos.app")!) {
            HStack {
              Image(systemName: "envelope")
                .foregroundColor(themeManager.accent(for: colorScheme))
              Text("Contact Support")
            }
          }

          Link(destination: URL(string: "https://cronos.app/privacy")!) {
            HStack {
              Image(systemName: "hand.raised")
                .foregroundColor(themeManager.accent(for: colorScheme))
              Text("Privacy Policy")
            }
          }

          Link(destination: URL(string: "https://cronos.app/terms")!) {
            HStack {
              Image(systemName: "doc.text")
                .foregroundColor(themeManager.accent(for: colorScheme))
              Text("Terms of Service")
            }
          }
        }
      }
      .scrollContentBackground(.hidden)
      .background(themeManager.primaryBackground(for: colorScheme))
      .navigationTitle("Settings")
      .navigationBarTitleDisplayMode(.large)
      .tint(themeManager.accent(for: colorScheme))
      .sheet(isPresented: $showingThemePicker) {
        ThemePickerView()
      }
      .alert("Delete All Data", isPresented: $showingDeleteAlert) {
        Button("Cancel", role: .cancel) {}
        Button("Delete", role: .destructive) {
          deleteAllData()
        }
      } message: {
        Text(
          "This action cannot be undone. All deadlines and categories will be permanently deleted.")
      }
    }
  }

  private func deleteAllData() {
    withAnimation {
      // Delete all deadlines and categories
      do {
        try modelContext.delete(model: Deadline.self)
        try modelContext.delete(model: Category.self)
      } catch {
        print("Error deleting data: \(error)")
      }
    }
  }
}

#Preview {
  SettingsView()
    .modelContainer(for: [Deadline.self, Category.self], inMemory: true)
    .environmentObject(ThemeManager())
}
