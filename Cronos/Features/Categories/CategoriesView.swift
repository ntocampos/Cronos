//
//  CategoriesView.swift
//  Cronos
//
//  Created by Assistant on 11/10/25.
//

import SwiftData
import SwiftUI

struct CategoriesView: View {
  @Environment(DataContainer.self) private var dataContainer
  @Query(sort: \Category.sortOrder, order: .forward) private var categories: [Category]
  @State private var showingAddCategory = false
  @State private var categoryToEdit: Category?
  @State private var editMode: EditMode = .inactive
  @State private var categoryToDelete: Category?
  @State private var showingDeleteConfirmation = false

  var body: some View {
    NavigationView {
      ZStack {
        List {
          ForEach(categories) { category in
            CategoryRowView(category: category)
              .padding(.horizontal)
              .padding(.vertical, 8)
              .listRowSeparator(.hidden)
              .listRowInsets(EdgeInsets())
              .listRowBackground(Color.clear)
              .deleteDisabled(category.isDefault)
              .onTapGesture {
                if editMode == .inactive {
                  categoryToEdit = category
                }
              }
              .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                if !category.isDefault {
                  Button(role: .destructive) {
                    requestDeleteCategory(category)
                  } label: {
                    Label("Delete", systemImage: "trash")
                  }
                }
              }
          }
          .onMove(perform: moveCategories)
        }
        .listStyle(.plain)
        .environment(\.editMode, $editMode)
        .scrollContentBackground(.hidden)
        .navigationTitle("Categories")
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            if !categories.isEmpty {
              Button(editMode == .inactive ? "Edit" : "Done") {
                withAnimation {
                  editMode = editMode == .inactive ? .active : .inactive
                }
              }
            }
          }
          ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { showingAddCategory = true }) {
              Label("Add Category", systemImage: "plus")
            }
          }
        }
        .fullScreenCover(isPresented: $showingAddCategory) {
          CategoryFormView()
        }
        .fullScreenCover(item: $categoryToEdit) { category in
          CategoryFormView(category: category)
        }
        .overlay {
          if categories.isEmpty {
            ContentUnavailableView(
              "No Categories",
              systemImage: "folder",
              description: Text("Add categories to organize your deadlines")
            )
          }
        }
        .alert("Delete Category", isPresented: $showingDeleteConfirmation) {
          Button("Cancel", role: .cancel) {
            categoryToDelete = nil
          }
          Button("Delete", role: .destructive) {
            if let category = categoryToDelete {
              performDeleteCategory(category)
            }
          }
        } message: {
          if let category = categoryToDelete {
            let count = category.deadlines.count
            if count > 0 {
              let defaultCategory = dataContainer.getDefaultCategory()
              let defaultName = defaultCategory?.name ?? "the default category"
              Text(
                "This category has \(count) deadline\(count == 1 ? "" : "s"). They will be reassigned to \"\(defaultName)\"."
              )
            } else {
              Text("Are you sure you want to delete \"\(category.name)\"?")
            }
          }
        }
      }
    }
  }

  private func moveCategories(from source: IndexSet, to destination: Int) {
    var reorderedCategories = categories
    reorderedCategories.move(fromOffsets: source, toOffset: destination)

    for (index, category) in reorderedCategories.enumerated() {
      category.sortOrder = index
    }

    try? dataContainer.context.save()
  }

  private func requestDeleteCategory(_ category: Category) {
    // Don't allow deleting the default category
    guard !category.isDefault else { return }

    categoryToDelete = category
    showingDeleteConfirmation = true
  }

  private func performDeleteCategory(_ category: Category) {
    guard let defaultCategory = dataContainer.getDefaultCategory() else { return }

    withAnimation {
      // Reassign all deadlines to the default category
      for deadline in category.deadlines {
        deadline.category = defaultCategory
      }

      // Delete the category
      dataContainer.context.delete(category)
      categoryToDelete = nil
    }
  }
}

#Preview {
  NavigationView {
    CategoriesView()
  }
  .sampleDataContainer()
}
