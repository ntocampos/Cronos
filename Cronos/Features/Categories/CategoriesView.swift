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
  @State private var newCategoryName = ""

  var body: some View {
    NavigationView {
      List {
        ForEach(categories) { category in
          CategoryRowView(category: category)
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
        AddCategoryView()
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

struct CategoryRowView: View {
  let category: Category

  var body: some View {
    HStack {
      Circle()
        .fill(category.color)
        .frame(width: 16, height: 16)

      Text(category.name)
        .font(.headline)

      Spacer()

      Text("\(category.deadlines.count)")
        .font(.caption)
        .foregroundColor(.secondary)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.secondary.opacity(0.2))
        .clipShape(Capsule())
    }
    .padding(.vertical, 4)
  }
}

struct AddCategoryView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var modelContext
  @State private var name = ""
  @State private var selectedColorHex = Category.DefaultColors.blue

  private let availableColors = Category.DefaultColors.all

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
                        selectedColorHex == colorHex ? Color.primary : Color.clear, lineWidth: 3)
                  )
              }
            }
          }
          .padding(.vertical, 8)
        }
      }
      .navigationTitle("Add Category")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button("Cancel") {
            dismiss()
          }
        }

        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Save") {
            saveCategory()
          }
          .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
        }
      }
    }
  }

  private func saveCategory() {
    let trimmedName = name.trimmingCharacters(in: .whitespaces)
    guard !trimmedName.isEmpty else { return }

    withAnimation {
      let newCategory = Category(name: trimmedName, colorHex: selectedColorHex)
      modelContext.insert(newCategory)
    }
    dismiss()
  }
}

#Preview {
  NavigationView {
    CategoriesView()
  }
  .modelContainer(for: [Category.self, Deadline.self], inMemory: true)
}
