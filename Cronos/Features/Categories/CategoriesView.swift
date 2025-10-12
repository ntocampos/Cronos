//
//  CategoriesView.swift
//  Cronos
//
//  Created by Assistant on 11/10/25.
//

import SwiftData
import SwiftUI

struct CategoriesView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \Category.name, order: .forward) private var categories: [Category]
  @State private var showingAddCategory = false
  @State private var categoryToEdit: Category?

  var body: some View {
    NavigationView {
      List {
        ForEach(categories) { category in
          CategoryRowView(category: category)
            .onTapGesture {
              categoryToEdit = category
            }
        }
        .onDelete(perform: deleteCategories)
      }
      .navigationTitle("Categories")
      .toolbar {
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

  private func deleteCategories(offsets: IndexSet) {
    withAnimation {
      for index in offsets {
        modelContext.delete(categories[index])
      }
    }
  }
}

#Preview {
  NavigationView {
    CategoriesView()
  }
  .modelContainer(for: [Category.self, Deadline.self], inMemory: true)
}
