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
  var internalPadding: CGFloat = 4

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
        .fill(Color(.secondarySystemFill).opacity(0.3))
        .glassEffect(in: .rect(cornerRadius: outerCornerRadius))

      // Colored middle view
      GeometryReader { geometry in
        let availableWidth = geometry.size.width - (2 * internalPadding)
        let calculatedWidth = availableWidth * barWidth
        let finalWidth = max(
          minimumColoredWidth,
          min(availableWidth, calculatedWidth)
        )

        HStack(spacing: 0) {
          Spacer(minLength: 0)  // Pushes the rectangle to the right
          RoundedRectangle(cornerRadius: innerCornerRadius)
            .fill(categoryColor.opacity(0.3))
            .frame(width: finalWidth)
            .glassEffect(in: .rect(cornerRadius: innerCornerRadius))
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
            .shadow(color: .primary.opacity(0.1), radius: 6)

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
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .glassEffect(in: .rect(cornerRadius: 6))
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
  ScrollView {
    VStack(alignment: .leading, spacing: 12) {
      ForEach(Deadline.sampleData) { deadline in
        DeadlineBarView(deadline: deadline)
      }
    }
  }
  .sampleDataContainer()
}
