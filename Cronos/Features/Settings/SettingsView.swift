//
//  SettingsView.swift
//  Cronos
//
//  Created by Assistant on 11/10/25.
//

import SwiftData
import SwiftUI

struct SettingsView: View {
  @Environment(DataContainer.self) private var dataContainer
  @Query(sort: \Category.sortOrder, order: .forward) private var categories: [Category]
  @AppStorage("showNotifications") private var showNotifications = true
  @AppStorage("defaultReminderDays") private var defaultReminderDays = 3
  @AppStorage(SettingsKeys.defaultCategoryId) private var defaultCategoryId: String = ""
  @State private var showingDeleteAlert = false

  var body: some View {
    NavigationView {
      Form {
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

        Section(header: Text("Categories")) {
          Picker("Default Category", selection: $defaultCategoryId) {
            ForEach(categories) { category in
              HStack {
                Circle()
                  .fill(category.color)
                  .frame(width: 12, height: 12)
                Text(category.name)
              }
              .tag(category.id.uuidString)
            }
          }
          .pickerStyle(.menu)

          Text("The default category is used for new deadlines and cannot be deleted.")
            .font(.caption)
            .foregroundStyle(.secondary)
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
                .foregroundColor(.red)
              Text("Delete All Data")
                .foregroundColor(.red)
            }
          }
        }

        Section(header: Text("Support")) {
          Link(destination: URL(string: "mailto:support@cronos.app")!) {
            HStack {
              Image(systemName: "envelope")
              Text("Contact Support")
            }
          }

          Link(destination: URL(string: "https://cronos.app/privacy")!) {
            HStack {
              Image(systemName: "hand.raised")
              Text("Privacy Policy")
            }
          }

          Link(destination: URL(string: "https://cronos.app/terms")!) {
            HStack {
              Image(systemName: "doc.text")
              Text("Terms of Service")
            }
          }
        }
      }
      .navigationTitle("Settings")
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
        try dataContainer.context.delete(model: Deadline.self)
        try dataContainer.context.delete(model: Category.self)

        // Reset the default category setting
        UserDefaults.standard.removeObject(forKey: SettingsKeys.defaultCategoryId)

        // Create a new default "General" category
        let generalCategory = Category(
          name: "General",
          colorHex: Category.DefaultColors.blue,
          sortOrder: 0
        )
        dataContainer.context.insert(generalCategory)
        defaultCategoryId = generalCategory.id.uuidString
      } catch {
        print("Error deleting data: \(error)")
      }
    }
  }
}

#Preview {
  SettingsView()
    .sampleDataContainer()
}
