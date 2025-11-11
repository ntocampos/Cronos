//
//  DeadlineFormView.swift
//  Cronos
//
//  Created by Assistant on 11/10/25.
//

import SwiftData
import SwiftUI

struct DeadlineFormView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var modelContext
  @Environment(\.colorScheme) private var colorScheme
  @EnvironmentObject private var themeManager: ThemeManager
  @Query(sort: \Category.sortOrder, order: .forward) private var categories: [Category]

  let deadline: Deadline?

  @State private var title: String
  @State private var notes: String
  @State private var date: Date
  @State private var selectedCategory: Category?

  private var isEditing: Bool { deadline != nil }
  private var navigationTitle: String { isEditing ? "Edit Deadline" : "Add Deadline" }
  private var saveButtonTitle: String { isEditing ? "Save" : "Add" }

  init(deadline: Deadline? = nil) {
    self.deadline = deadline
    self._title = State(initialValue: deadline?.title ?? "")
    self._notes = State(initialValue: deadline?.notes ?? "")
    self._date = State(initialValue: deadline?.date ?? Date().addingTimeInterval(86400))  // Default to tomorrow
    self._selectedCategory = State(initialValue: deadline?.category)
  }

  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Deadline Details")) {
          TextField("Title", text: $title)

          TextField("Notes (optional)", text: $notes, axis: .vertical)
            .lineLimit(3...6)
        }

        Section(header: Text("Date & Time")) {
          DatePicker(
            "Due Date",
            selection: $date,
            displayedComponents: [.date, .hourAndMinute]
          )
          .datePickerStyle(.compact)
        }

        Section(header: Text("Category")) {
          if categories.isEmpty {
            HStack {
              Image(systemName: "folder.badge.plus")
                .foregroundColor(.secondary)
              Text("No categories available")
                .foregroundColor(.secondary)
              Spacer()
              Button("Create One") {
                // This could open the category form, but for now just show text
                // In a real implementation, you might want to dismiss this and open category creation
              }
              .font(.caption)
              .buttonStyle(.bordered)
            }
          } else {
            Picker("Category", selection: $selectedCategory) {
              Text("None")
                .tag(nil as Category?)

              ForEach(categories) { category in
                HStack {
                  Circle()
                    .fill(category.color(using: themeManager, for: colorScheme))
                    .frame(width: 12, height: 12)
                  Text(category.name)
                }
                .tag(category as Category?)
              }
            }
            .pickerStyle(.menu)
          }
        }

        if isEditing {
          Section(header: Text("Information")) {
            HStack {
              Text("Created")
              Spacer()
              Text(deadline?.date.formatted(date: .abbreviated, time: .shortened) ?? "")
                .foregroundColor(.secondary)
            }

            if let daysUntil = deadline?.daysUntil {
              HStack {
                Text("Time Remaining")
                Spacer()
                if daysUntil < 0 {
                  Text("Overdue")
                    .foregroundColor(themeManager.destructive(for: colorScheme))
                } else if daysUntil == 0 {
                  Text("Today")
                    .foregroundColor(themeManager.categoryColor(at: 3, for: colorScheme))
                } else if daysUntil == 1 {
                  Text("Tomorrow")
                    .foregroundColor(themeManager.accent(for: colorScheme))
                } else {
                  Text("\(daysUntil) days")
                    .foregroundColor(themeManager.secondaryText(for: colorScheme))
                }
              }
            }
          }
        }
      }
      .navigationTitle(navigationTitle)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button("Cancel") {
            dismiss()
          }
        }

        ToolbarItem(placement: .navigationBarTrailing) {
          Button(saveButtonTitle) {
            saveDeadline()
          }
          .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
        }
      }
    }
    .presentationDetents([.large, .medium])
    .presentationDragIndicator(.visible)
  }

  private func saveDeadline() {
    let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
    guard !trimmedTitle.isEmpty else { return }

    let trimmedNotes = notes.trimmingCharacters(in: .whitespaces)
    let finalNotes = trimmedNotes.isEmpty ? nil : trimmedNotes

    withAnimation {
      if let existingDeadline = deadline {
        // Edit existing deadline
        existingDeadline.title = trimmedTitle
        existingDeadline.notes = finalNotes
        existingDeadline.date = date
        existingDeadline.category = selectedCategory
      } else {
        // Create new deadline
        let newDeadline = Deadline(
          title: trimmedTitle,
          notes: finalNotes,
          date: date,
          category: selectedCategory
        )
        modelContext.insert(newDeadline)
      }
    }
    dismiss()
  }
}

#Preview("Add Deadline") {
  let container = ModelContainer.emptyPreview
  SampleData.addSampleCategories(to: container.mainContext)

  return DeadlineFormView()
    .modelContainer(container)
    .environmentObject(ThemeManager())
}

#Preview("Edit Deadline") {
  let container = ModelContainer.emptyPreview
  let category = Category(name: "Work", colorHex: Category.DefaultColors.blue)
  let deadline = Deadline(
    title: "Submit Report",
    notes: "Quarterly financial report due to management",
    date: Date().addingTimeInterval(86400 * 3),
    category: category
  )
  container.mainContext.insert(category)
  container.mainContext.insert(deadline)

  return DeadlineFormView(deadline: deadline)
    .modelContainer(container)
    .environmentObject(ThemeManager())
}
