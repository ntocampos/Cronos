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
  var maxDaysReference: Double = 30
  var internalPadding: CGFloat = 2

  private let outerCornerRadius: CGFloat = 16

  private var innerCornerRadius: CGFloat {
    outerCornerRadius - internalPadding
  }

  private var minimumColoredWidth: CGFloat {
    2 * innerCornerRadius
  }

  private var barWidth: Double {
    guard let daysUntil = deadline.daysUntil else { return 1.0 }

    // Inverse proportionality - closer deadlines get wider bars
    let maxDays: Double = maxDaysReference
    let minWidth: Double = 0.04  // Minimum 20% width

    if daysUntil <= 0 {
      return 1.0  // Full width for overdue
    }

    // Calculate inverse proportion: fewer days = wider bar
    let width = max(minWidth, 1.0 - (Double(daysUntil) / maxDays))
    return min(1.0, width)
  }

  private var categoryColor: Color {
    return deadline.category?.color ?? .gray
  }

  var body: some View {
    ZStack(alignment: .topLeading) {
      // White background
      RoundedRectangle(cornerRadius: outerCornerRadius)
        .fill(Color(.systemBackground))

      // Colored middle view
      GeometryReader { geometry in
        let availableWidth = geometry.size.width - (2 * internalPadding)
        let calculatedWidth = availableWidth * barWidth
        let finalWidth = max(minimumColoredWidth, min(availableWidth, calculatedWidth))

        HStack(spacing: 0) {
          Spacer(minLength: 0)  // Pushes the rectangle to the right
          RoundedRectangle(cornerRadius: innerCornerRadius)
            .fill(categoryColor.opacity(0.3))
            .frame(width: finalWidth)
        }
        .padding(internalPadding)
      }

      // Content
      HStack {
        VStack(alignment: .leading) {
          Text(deadline.title)
            .font(.body)
            .fontWeight(.semibold)
            .lineLimit(1)
            .padding(.trailing, 8)

          Text(deadline.notes ?? "No description")
            .font(.footnote)
            .foregroundColor(Color(.secondaryLabel))
            .lineLimit(1)
            .padding(.trailing, 8)
            .opacity(deadline.notes == nil ? 0 : 1)

          Text(deadline.category?.name ?? "No category")
            .font(.caption2)
            .fontWeight(.medium)
            .foregroundColor(categoryColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background {
              RoundedRectangle(cornerRadius: 6)
                .fill(categoryColor.opacity(0.2))
            }
            .opacity(deadline.category == nil ? 0 : 1)
        }

        Spacer()

        VStack(alignment: .leading) {
          HStack(alignment: .center) {
            if let daysUntil = deadline.daysUntil, daysUntil > 0 {
              Text(deadline.daysUntilText)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(categoryColor)
            }

            Image(systemName: "chevron.right")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 12, height: 12)
              .foregroundStyle(categoryColor)
          }
          .padding(.vertical, 6)
          Spacer()
        }
      }
      .padding()
    }
    .clipShape(
      RoundedRectangle(cornerRadius: outerCornerRadius)
    )
    .shadow(color: Color.primary.opacity(0.1), radius: 8, x: 0, y: 2)
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
      date: Date()
        .addingTimeInterval(86400 * 25),  // 25 days (should be narrow)
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
    VStack(alignment: .leading, spacing: 12) {
      Text("DeadlineBarView Preview")
        .font(.title2)
        .bold()
        .padding(.bottom)

      Group {
        Text("Overdue (Full Width)")
          .font(.caption)
          .foregroundColor(.secondary)
        DeadlineBarView(deadline: testDeadlines[0])

        Text("Due Today")
          .font(.caption)
          .foregroundColor(.secondary)
        DeadlineBarView(deadline: testDeadlines[1])

        Text("Due Tomorrow")
          .font(.caption)
          .foregroundColor(.secondary)
        DeadlineBarView(deadline: testDeadlines[2])

        Text("Due in 1 Week")
          .font(.caption)
          .foregroundColor(.secondary)
        DeadlineBarView(deadline: testDeadlines[3])

        Text("Due in 25 Days (Title Outside)")
          .font(.caption)
          .foregroundColor(.secondary)
        DeadlineBarView(deadline: testDeadlines[4])

        Text("Due in 35+ Days (Minimum Width, No Category)")
          .font(.caption)
          .foregroundColor(.secondary)
        DeadlineBarView(deadline: testDeadlines[5])
      }
    }
    .padding()
  }
  .modelContainer(container)
}
