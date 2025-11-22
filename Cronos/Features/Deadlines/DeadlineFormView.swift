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
  @Environment(DataContainer.self) private var dataContainer
  @Query(sort: \Category.sortOrder, order: .forward) private var categories: [Category]

  // Deadline being edited (nil for new deadline)
  let deadline: Deadline?

  @State private var title: String
  @State private var notes: String
  @State private var date: Date
  @State private var selectedCategory: Category?
  @State private var hasInitializedCategory = false

  // Computed properties
  private var isEditing: Bool { deadline != nil }
  private var navigationTitle: String { isEditing ? "Edit Deadline" : "Add Deadline" }
  private var saveButtonTitle: String { isEditing ? "Save" : "Add" }
  private var canSave: Bool {
    !title.trimmingCharacters(in: .whitespaces).isEmpty && selectedCategory != nil
  }

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
          Picker("Category", selection: $selectedCategory) {
            ForEach(categories) { category in
              HStack {
                Circle()
                  .fill(category.color)
                  .frame(width: 12, height: 12)
                Text(category.name)
                if category.isDefault {
                  Text("Default")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
              }
              .tag(category as Category?)
            }
          }
          .pickerStyle(.menu)
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
                    .foregroundColor(.red)
                } else if daysUntil == 0 {
                  Text("Today")
                    .foregroundColor(.orange)
                } else if daysUntil == 1 {
                  Text("Tomorrow")
                    .foregroundColor(.blue)
                } else {
                  Text("\(daysUntil) days")
                    .foregroundColor(.secondary)
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
          .disabled(!canSave)
        }
      }
    }
    .presentationDetents([.large, .medium])
    .presentationDragIndicator(.visible)
    .onAppear {
      initializeCategoryIfNeeded()
    }
  }

  private func initializeCategoryIfNeeded() {
    guard !hasInitializedCategory else { return }
    hasInitializedCategory = true

    // For new deadlines, set the default category
    if deadline == nil && selectedCategory == nil {
      selectedCategory = dataContainer.getDefaultCategory() ?? categories.first
    }
  }

  private func saveDeadline() {
    let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
    guard !trimmedTitle.isEmpty else { return }
    guard let category = selectedCategory else { return }

    let trimmedNotes = notes.trimmingCharacters(in: .whitespaces)
    let finalNotes = trimmedNotes.isEmpty ? nil : trimmedNotes

    withAnimation {
      if let existingDeadline = deadline {
        // Edit existing deadline
        existingDeadline.title = trimmedTitle
        existingDeadline.notes = finalNotes
        existingDeadline.date = date
        existingDeadline.category = category
      } else {
        // Create new deadline
        let newDeadline = Deadline(
          title: trimmedTitle,
          notes: finalNotes,
          date: date,
          category: category
        )
        dataContainer.context.insert(newDeadline)
      }
    }
    dismiss()
  }
}

#Preview("Add Deadline") {
  DeadlineFormView()
    .sampleDataContainer()
}

#Preview("Edit Deadline") {
  DeadlineFormView(deadline: Deadline.sample)
    .sampleDataContainer()
}
