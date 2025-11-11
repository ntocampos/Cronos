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
  @Environment(\.modelContext) private var modelContext
  @Environment(\.colorScheme) private var colorScheme
  @EnvironmentObject private var themeManager: ThemeManager

  let category: Category?

  @State private var name: String
  @State private var selectedColorIndex: Int

  private var isEditing: Bool { category != nil }
  private var navigationTitle: String { isEditing ? "Edit Category" : "Add Category" }
  private var saveButtonTitle: String { isEditing ? "Save" : "Add" }

  init(category: Category? = nil) {
    self.category = category
    self._name = State(initialValue: category?.name ?? "")
    self._selectedColorIndex = State(initialValue: category?.colorIndex ?? 0)
  }

  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Category Details")) {
          TextField("Category Name", text: $name)
        }

        Section {
          LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 12) {
            ForEach(0..<10, id: \.self) { index in
              Button(action: {
                selectedColorIndex = index
              }) {
                Circle()
                  .fill(themeManager.categoryColor(at: index, for: colorScheme))
                  .frame(width: 40, height: 40)
                  .overlay(
                    Circle()
                      .stroke(
                        selectedColorIndex == index ? Color.primary : Color.clear,
                        lineWidth: 3
                      )
                  )
              }
              .buttonStyle(.plain)
            }
          }
          .padding(.vertical, 8)
        } header: {
          Text("Color")
        } footer: {
          Text("Colors are set by your current theme (\(themeManager.currentTheme.name))")
            .font(.caption)
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
        existingCategory.name = trimmedName
        existingCategory.setColorIndex(selectedColorIndex)
      } else {
        let fetchDescriptor = FetchDescriptor<Category>(
          sortBy: [SortDescriptor(\.sortOrder, order: .reverse)]
        )

        let maxSortOrder = (try? modelContext.fetch(fetchDescriptor).first?.sortOrder) ?? -1
        let newCategory = Category(
          name: trimmedName,
          colorHex: Category.DefaultColors.classicHexValues[selectedColorIndex],
          sortOrder: maxSortOrder + 1
        )
        modelContext.insert(newCategory)
      }
    }
    dismiss()
  }
}

#Preview("Add Category") {
  CategoryFormView()
    .modelContainer(.emptyPreview)
    .environmentObject(ThemeManager())
}

#Preview("Edit Category") {
  let container = ModelContainer.emptyPreview
  let category = Category(name: "Work", colorHex: Category.DefaultColors.blue)
  container.mainContext.insert(category)

  return CategoryFormView(category: category)
    .modelContainer(container)
    .environmentObject(ThemeManager())
}
