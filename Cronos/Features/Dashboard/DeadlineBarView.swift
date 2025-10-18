//
//  DeadlineBarView.swift
//  Cronos
//
//  Created by Assistant on 11/10/25.
//

import SwiftData
import SwiftUI

struct DeadlineBarView: View {
  let deadline: Deadline

  private var barWidth: Double {
    guard let daysUntil = deadline.daysUntil else { return 1.0 }

    // Inverse proportionality - closer deadlines get wider bars
    let maxDays: Double = 30
    let minWidth: Double = 0.1  // Minimum 10% width

    if daysUntil <= 0 {
      return 1.0  // Full width for overdue
    }

    // Calculate inverse proportion: fewer days = wider bar
    let width = max(minWidth, 1.0 - (Double(daysUntil) / maxDays))
    return min(1.0, width)
  }

  private var shouldShowTitleOutside: Bool {
    // Show title outside if bar is narrower than 30% of the screen
    return barWidth < 0.3
  }

  private var barColor: Color {
    return deadline.category?.color ?? .gray
  }

  private var textColor: Color {
    // Determine if the category color is light or dark to choose contrasting text color
    let categoryColor = deadline.category?.color ?? .gray

    // For simplicity, we'll use white for darker colors and black for lighter ones
    // You might want to implement a more sophisticated contrast calculation
    if categoryColor == .yellow || categoryColor == .white {
      return .black
    } else {
      return .white
    }
  }

  private var deadlineTitle: some View {
    Text(deadline.title)
      .font(.subheadline)
      .fontWeight(.semibold)
      .lineLimit(1)
      .padding(.trailing, 8)
  }

  var body: some View {
    HStack {
      GeometryReader { geometry in
        HStack {
          Spacer(minLength: 0)

          if shouldShowTitleOutside {
            deadlineTitle
              .foregroundColor(.primary)
          }

          RoundedRectangle(cornerRadius: 8)
            .fill(barColor)
            .frame(width: geometry.size.width * barWidth)
            .overlay(
              shouldShowTitleOutside
                ? nil
                : deadlineTitle.foregroundColor(textColor),
              alignment: .center
            )
        }
      }
    }
  }
}

#Preview {
  let container = ModelContainer.emptyPreview

  // Create categories with different colors
  let workCategory = Category(
    name: "Work",
    colorHex: Category.DefaultColors.blue
  )
  let personalCategory = Category(
    name: "Personal",
    colorHex: Category.DefaultColors.green
  )
  let urgentCategory = Category(
    name: "Urgent",
    colorHex: Category.DefaultColors.red
  )
  let studyCategory = Category(
    name: "Study",
    colorHex: Category.DefaultColors.purple
  )

  // Create deadlines with varying time distances to test different bar widths
  let testDeadlines = [
    Deadline(
      title: "Overdue Task",
      notes: "This should be a full-width red bar",
      date: Date().addingTimeInterval(-86400 * 2),  // 2 days ago
      category: urgentCategory
    ),
    Deadline(
      title: "Due Today",
      notes: "Very urgent deadline",
      date: Date(),
      category: workCategory
    ),
    Deadline(
      title: "Submit Quarterly Report to Management",
      notes: "Long title to test text handling",
      date: Date().addingTimeInterval(86400),  // Tomorrow
      category: workCategory
    ),
    Deadline(
      title: "Team Meeting Preparation",
      notes: "Medium urgency",
      date: Date().addingTimeInterval(86400 * 7),  // 1 week
      category: personalCategory
    ),
    Deadline(
      title: "Long Term Project Review and Final Presentation",
      notes: "This should show title outside the bar",
      date: Date().addingTimeInterval(86400 * 25),  // 25 days (should be narrow)
      category: studyCategory
    ),
    Deadline(
      title: "Annual Conference Planning Committee Meeting",
      notes: "Very narrow bar test",
      date: Date().addingTimeInterval(86400 * 35),  // 35+ days (minimum width)
      category: nil  // No category to test gray fallback
    ),
  ]

  // Insert data
  let context = container.mainContext
  context.insert(workCategory)
  context.insert(personalCategory)
  context.insert(urgentCategory)
  context.insert(studyCategory)

  for deadline in testDeadlines {
    context.insert(deadline)
  }

  return ScrollView {
    VStack(spacing: 12) {
      Text("DeadlineBarView Preview")
        .font(.title2)
        .bold()
        .padding(.bottom)

      Group {
        Text("Overdue (Full Width)")
          .font(.caption)
          .foregroundColor(.secondary)
        DeadlineBarView(deadline: testDeadlines[0])
          .frame(height: 40)

        Text("Due Today")
          .font(.caption)
          .foregroundColor(.secondary)
        DeadlineBarView(deadline: testDeadlines[1])
          .frame(height: 40)

        Text("Due Tomorrow")
          .font(.caption)
          .foregroundColor(.secondary)
        DeadlineBarView(deadline: testDeadlines[2])
          .frame(height: 40)

        Text("Due in 1 Week")
          .font(.caption)
          .foregroundColor(.secondary)
        DeadlineBarView(deadline: testDeadlines[3])
          .frame(height: 40)

        Text("Due in 25 Days (Title Outside)")
          .font(.caption)
          .foregroundColor(.secondary)
        DeadlineBarView(deadline: testDeadlines[4])
          .frame(height: 40)

        Text("Due in 35+ Days (Minimum Width, No Category)")
          .font(.caption)
          .foregroundColor(.secondary)
        DeadlineBarView(deadline: testDeadlines[5])
          .frame(height: 40)
      }
    }
    .padding()
  }
  .modelContainer(container)
}
