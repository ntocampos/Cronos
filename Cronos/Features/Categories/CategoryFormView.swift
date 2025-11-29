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

  // Form state
  @State private var name: String
  @State private var selectedColorHex: String

  // Focus management
  @FocusState private var isNameFocused: Bool

  private let availableColors = Category.DefaultColors.all

  // Computed properties
  private var isEditing: Bool { category != nil }
  private var saveButtonTitle: String { isEditing ? "Save" : "Create" }
  private var canSave: Bool {
    !name.trimmingCharacters(in: .whitespaces).isEmpty
  }
  private var accentColor: Color {
    Color(hex: selectedColorHex)
  }

  init(category: Category? = nil) {
    self.category = category
    self._name = State(initialValue: category?.name ?? "")
    self._selectedColorHex = State(initialValue: category?.colorHex ?? Category.DefaultColors.blue)
  }

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        // Plain background
        Color(.systemBackground)
          .ignoresSafeArea()

        // Subtle radial gradient from bottom-right corner
        RadialGradient(
          colors: [
            accentColor.opacity(0.15),
            accentColor.opacity(0.05),
            Color.clear,
          ],
          center: .bottomTrailing,
          startRadius: 0,
          endRadius: geometry.size.height * 0.8
        )
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 0.3), value: accentColor)

        VStack(spacing: 0) {
          // Header with glass buttons
          headerView

          // Scrollable form content
          ScrollView {
            VStack(alignment: .leading, spacing: 32) {
              // Name section (largest visual weight)
              nameSection

              // Color selection
              colorSection

              // Statistics (edit mode only)
              if isEditing {
                statisticsSection
              }
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .padding(.bottom, 40)
          }
          .scrollDismissesKeyboard(.interactively)
        }
      }
      .onAppear {
        // Auto-focus name for new categories
        if !isEditing {
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isNameFocused = true
          }
        }
      }
      .contentShape(Rectangle())
      .onTapGesture {
        isNameFocused = false
      }
    }
  }

  // MARK: - Header View

  private var headerView: some View {
    HStack {
      // Cancel button - glass secondary style
      Button("Cancel") {
        dismiss()
      }
      .font(.body)
      .foregroundStyle(.primary)
      .padding(.horizontal, 16)
      .padding(.vertical, 8)
      .glassEffect(.regular.interactive())

      Spacer()

      // Save button - glass primary style with accent color
      Button(saveButtonTitle) {
        saveCategory()
      }
      .font(.body)
      .fontWeight(.semibold)
      .foregroundStyle(canSave ? .white : .secondary)
      .padding(.horizontal, 16)
      .padding(.vertical, 8)
      .disabled(!canSave)
      .glassEffect(.regular.tint(canSave ? accentColor : Color(.secondarySystemFill)).interactive())
      .animation(.easeInOut(duration: 0.2), value: canSave)
      .animation(.easeInOut(duration: 0.2), value: accentColor)
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 12)
  }

  // MARK: - Name Section

  private var nameSection: some View {
    LargeInlineTextField(
      text: $name,
      placeholder: "Category name",
      isFocused: $isNameFocused
    )
  }

  // MARK: - Color Section

  private var colorSection: some View {
    ColorPillSelector(
      colors: availableColors,
      selectedColorHex: $selectedColorHex
    )
  }

  // MARK: - Statistics Section

  private var statisticsSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      FormSectionHeader("Statistics", icon: "chart.bar")

      HStack {
        Text("Associated Deadlines")
          .font(.body)
        Spacer()
        Text("\(category?.deadlines.count ?? 0)")
          .font(.body)
          .fontWeight(.semibold)
          .foregroundStyle(accentColor)
      }
      .padding(16)
      .background(
        RoundedRectangle(cornerRadius: 16)
          .fill(Color(.secondarySystemFill).opacity(0.3))
          .glassEffect(in: .rect(cornerRadius: 16))
      )
    }
  }

  // MARK: - Actions

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
