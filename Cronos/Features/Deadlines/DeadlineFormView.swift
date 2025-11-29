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

  // Form state
  @State private var title: String
  @State private var notes: String
  @State private var date: Date
  @State private var selectedCategory: Category?
  @State private var hasInitializedCategory = false
  @State private var showingDatePicker = false

  // Focus management
  @FocusState private var isTitleFocused: Bool
  @FocusState private var isNotesFocused: Bool

  // Computed properties
  private var isEditing: Bool { deadline != nil }
  private var saveButtonTitle: String { isEditing ? "Save" : "Create" }
  private var canSave: Bool {
    !title.trimmingCharacters(in: .whitespaces).isEmpty && selectedCategory != nil
  }
  private var accentColor: Color {
    selectedCategory?.color ?? .blue
  }

  private var relativeDate: String {
    let calendar = Calendar.current
    let startOfToday = calendar.startOfDay(for: Date())
    let startOfTarget = calendar.startOfDay(for: date)
    let days = calendar.dateComponents([.day], from: startOfToday, to: startOfTarget).day ?? 0

    if days < 0 { return "Overdue" }
    if days == 0 { return "Today" }
    if days == 1 { return "Tomorrow" }
    if days < 7 { return "In \(days) days" }
    let weeks = days / 7
    return weeks == 1 ? "In 1 week" : "In \(weeks) weeks"
  }

  init(deadline: Deadline? = nil) {
    self.deadline = deadline
    self._title = State(initialValue: deadline?.title ?? "")
    self._notes = State(initialValue: deadline?.notes ?? "")
    self._date = State(initialValue: deadline?.date ?? Date().addingTimeInterval(86400))
    self._selectedCategory = State(initialValue: deadline?.category)
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
            VStack(alignment: .leading, spacing: 28) {
              // Title section (largest visual weight)
              titleSection

              // Notes section (inline)
              notesSection

              // Date section (inline tappable)
              dateSection

              // Category selection
              categorySection

              // Info section (edit mode only)
              if isEditing {
                infoSection
              }
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 40)
          }
          .scrollDismissesKeyboard(.interactively)
        }
      }
    }
    .onAppear {
      initializeCategoryIfNeeded()
      // Auto-focus title for new deadlines
      if !isEditing {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
          isTitleFocused = true
        }
      }
    }
    .contentShape(Rectangle())
    .onTapGesture {
      isTitleFocused = false
      isNotesFocused = false
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
        saveDeadline()
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

  // MARK: - Title Section

  private var titleSection: some View {
    LargeInlineTextField(
      text: $title,
      placeholder: "What's the deadline?",
      isFocused: $isTitleFocused
    )
  }

  // MARK: - Notes Section (Inline)

  private var notesSection: some View {
    VStack(alignment: .leading, spacing: 8) {
      FormSectionHeader("Notes", icon: "note.text")

      ZStack(alignment: .topLeading) {
        if notes.isEmpty {
          Text("Add notes (optional)")
            .font(.body)
            .foregroundStyle(.tertiary)
            .allowsHitTesting(false)
        }

        TextField("", text: $notes, axis: .vertical)
          .font(.body)
          .focused($isNotesFocused)
          .lineLimit(3...6)
      }
    }
  }

  // MARK: - Date Section (Inline Tappable)

  private var dateSection: some View {
    VStack(alignment: .leading, spacing: 8) {
      FormSectionHeader("Due Date", icon: "calendar")

      Button(action: { showingDatePicker = true }) {
        VStack(alignment: .leading, spacing: 2) {
          // Relative date (prominent)
          Text(relativeDate)
            .font(.title3)
            .fontWeight(.medium)
            .foregroundStyle(relativeDate == "Overdue" ? .red : .primary)

          // Absolute date (secondary)
          Text(date.formatted(date: .abbreviated, time: .shortened))
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }

        Spacer()
      }
      .buttonStyle(.plain)
    }
    .sheet(isPresented: $showingDatePicker) {
      DatePickerSheet(selection: $date, accentColor: accentColor)
        .presentationDetents([.medium])
    }
  }

  // MARK: - Category Section

  private var categorySection: some View {
    CategoryPillSelector(
      categories: categories,
      selectedCategory: $selectedCategory
    )
  }

  // MARK: - Info Section (Edit Mode)

  private var infoSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      FormSectionHeader("Information", icon: "info.circle")

      VStack {
        infoRow(
          label: "Created",
          value: deadline?.date.formatted(date: .abbreviated, time: .shortened) ?? ""
        )

        if let daysUntil = deadline?.daysUntil {
          Divider()
            .padding(.vertical, 8)

          infoRow(
            label: "Time Remaining",
            value: formatTimeRemaining(daysUntil),
            valueColor: timeRemainingColor(daysUntil)
          )
        }
      }
      .padding(16)
      .glassEffect(.clear.interactive(), in: RoundedRectangle(cornerRadius: 16))
    }
  }

  private func infoRow(label: String, value: String, valueColor: Color = .secondary) -> some View {
    HStack {
      Text(label)
        .font(.body)
        .foregroundStyle(.primary)
      Spacer()
      Text(value)
        .font(.body)
        .fontWeight(.medium)
        .foregroundStyle(valueColor)
    }
  }

  private func formatTimeRemaining(_ days: Int) -> String {
    if days < 0 {
      return "Overdue"
    } else if days == 0 {
      return "Today"
    } else if days == 1 {
      return "Tomorrow"
    } else {
      return "\(days) days"
    }
  }

  private func timeRemainingColor(_ days: Int) -> Color {
    if days < 0 {
      return .red
    } else if days == 0 {
      return .orange
    } else if days == 1 {
      return .blue
    } else {
      return .secondary
    }
  }

  // MARK: - Actions

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
