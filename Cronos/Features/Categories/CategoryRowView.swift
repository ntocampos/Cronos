//
//  CategoryRowView.swift
//  Cronos
//
//  Created by Moisés Neto on 11/10/25.
//

import SwiftData
import SwiftUI

struct CategoryRowView: View {
  @Environment(\.colorScheme) private var colorScheme
  @EnvironmentObject private var themeManager: ThemeManager

  let category: Category

  var body: some View {
    HStack {
      Circle()
        .fill(category.color(using: themeManager, for: colorScheme))
        .frame(width: 16, height: 16)

      VStack(alignment: .leading, spacing: 2) {
        Text(category.name)
          .font(.headline)

        Text("Tap to edit")
          .font(.caption)
          .foregroundColor(.secondary)
      }

      Spacer()

      VStack(alignment: .trailing, spacing: 2) {
        Text("\(category.deadlines.count)")
          .font(.title2)
          .fontWeight(.semibold)
          .foregroundColor(.primary)

        Text(category.deadlines.count == 1 ? "deadline" : "deadlines")
          .font(.caption)
          .foregroundColor(.secondary)
      }
    }
    .padding(.vertical, 8)
    .contentShape(Rectangle())  // Makes entire row tappable
  }
}

#Preview {
  let container = ModelContainer.emptyPreview
  let workCategory = Category(name: "Work", colorHex: Category.DefaultColors.blue)
  let personalCategory = Category(name: "Personal", colorHex: Category.DefaultColors.green)

  // Add some deadlines to show count
  let deadline1 = Deadline(title: "Task 1", notes: "", date: Date(), category: workCategory)
  let deadline2 = Deadline(title: "Task 2", notes: "", date: Date(), category: workCategory)
  let deadline3 = Deadline(
    title: "Personal Task", notes: "", date: Date(), category: personalCategory)

  container.mainContext.insert(workCategory)
  container.mainContext.insert(personalCategory)
  container.mainContext.insert(deadline1)
  container.mainContext.insert(deadline2)
  container.mainContext.insert(deadline3)

  return VStack {
    CategoryRowView(category: workCategory)
    CategoryRowView(category: personalCategory)
    CategoryRowView(
      category: Category(name: "Empty Category", colorHex: Category.DefaultColors.orange))
  }
  .padding()
  .modelContainer(container)
  .environmentObject(ThemeManager())
}
