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
    let minWidth: Double = 0.2  // Minimum 20% width

    if daysUntil <= 0 {
      return 1.0  // Full width for overdue
    }

    // Calculate inverse proportion: fewer days = wider bar
    let width = max(minWidth, 1.0 - (Double(daysUntil) / maxDays))
    return min(1.0, width)
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

  var body: some View {
    HStack {
      Spacer()

      GeometryReader { geometry in
        HStack {
          Spacer()

          RoundedRectangle(cornerRadius: 8)
            .fill(barColor)
            .frame(width: geometry.size.width * barWidth)
            .overlay(
              Text(deadline.title)
                .font(.caption)
                .foregroundColor(textColor)
                .padding(.horizontal, 8)
                .lineLimit(1),
              alignment: .center
            )
        }
      }
    }
  }
}

#Preview {
  let container = try! ModelContainer(
    for: Deadline.self, Category.self,
    configurations: ModelConfiguration(isStoredInMemoryOnly: true))

  // Create sample data
  let category = Category(name: "Work", colorHex: Category.DefaultColors.blue)
  let deadline1 = Deadline(
    title: "Submit Report",
    notes: "Quarterly financial report due to management team",
    date: Date().addingTimeInterval(86400 * 3),  // 3 days from now
    category: category
  )
  let deadline2 = Deadline(
    title: "Team Meeting",
    notes: nil,
    date: Date().addingTimeInterval(-86400),  // Yesterday (overdue)
    category: nil
  )

  container.mainContext.insert(category)
  container.mainContext.insert(deadline1)
  container.mainContext.insert(deadline2)

  return VStack(spacing: 16) {
    DeadlineBarView(deadline: deadline1)
    DeadlineBarView(deadline: deadline2)
  }
  .padding()
  .modelContainer(container)
}
