//
//  CategoryFormView.swift
//  Cronos
//
//  Created by Assistant on 11/10/25.
//

import SwiftData
import SwiftUI

struct CategoryFormView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(DataContainer.self) private var dataContainer

  // Category being edited (nil for new category)
  let category: Category?

  @State private var name: String
  @State private var selectedColorHex: String

  private let availableColors = Category.DefaultColors.all

  // Computed properties
  private var isEditing: Bool { category != nil }
  private var navigationTitle: String { isEditing ? "Edit Category" : "Add Category" }
  private var saveButtonTitle: String { isEditing ? "Save" : "Add" }

  init(category: Category? = nil) {
    self.category = category
    self._name = State(initialValue: category?.name ?? "")
    self._selectedColorHex = State(initialValue: category?.colorHex ?? Category.DefaultColors.blue)
  }

  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Category Details")) {
          TextField("Category Name", text: $name)
        }

        Section(header: Text("Color")) {
          LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 12) {
            ForEach(availableColors, id: \.self) { colorHex in
              Button(action: {
                selectedColorHex = colorHex
              }) {
                Circle()
                  .fill(Color(hex: colorHex))
                  .frame(width: 40, height: 40)
                  .overlay(
                    Circle()
                      .stroke(
                        selectedColorHex == colorHex ? Color.primary : Color.clear,
                        lineWidth: 3
                      )
                  )
              }
              .buttonStyle(.plain)
            }
          }
          .padding(.vertical, 8)
        }

        if isEditing {
          Section(header: Text("Statistics")) {
            HStack {
              Text("Associated Deadlines")
              Spacer()
              Text("\(category?.deadlines.count ?? 0)")
                .foregroundColor(.secondary)
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
            saveCategory()
          }
          .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
        }
      }
    }
    .presentationDetents([.medium, .large])
    .presentationDragIndicator(.visible)
  }

  private func saveCategory() {
    let trimmedName = name.trimmingCharacters(in: .whitespaces)
    guard !trimmedName.isEmpty else { return }

    withAnimation {
      if let existingCategory = category {
        // Edit existing category
        existingCategory.name = trimmedName
        existingCategory.colorHex = selectedColorHex
      } else {
        // Create new category at the end of the list
        let fetchDescriptor = FetchDescriptor<Category>(
          sortBy: [SortDescriptor(\.sortOrder, order: .reverse)]
        )

        let maxSortOrder =
          (try? dataContainer.context.fetch(fetchDescriptor).first?.sortOrder) ?? -1
        let newCategory = Category(
          name: trimmedName,
          colorHex: selectedColorHex,
          sortOrder: maxSortOrder + 1
        )
        dataContainer.context.insert(newCategory)
      }
    }
    dismiss()
  }
}

#Preview("Add Category") {
  CategoryFormView()
    .sampleDataContainer()
}

#Preview("Edit Category") {
  return CategoryFormView(category: Category.work)
    .sampleDataContainer()
}
