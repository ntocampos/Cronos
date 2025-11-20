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
              .onTapGesture {
                if editMode == .inactive {
                  categoryToEdit = category
                }
              }
          }
          .onMove(perform: moveCategories)
          .onDelete(perform: deleteCategories)
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
        .sheet(isPresented: $showingAddCategory) {
          CategoryFormView()
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .sheet(item: $categoryToEdit) { category in
          CategoryFormView(category: category)
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
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

  private func deleteCategories(offsets: IndexSet) {
    withAnimation {
      for index in offsets {
        dataContainer.context.delete(categories[index])
      }
    }
  }

  private func deleteCategory(_ category: Category) {
    dataContainer.context.delete(category)
  }
}

#Preview {
  NavigationView {
    CategoriesView()
  }
  .sampleDataContainer()
}
