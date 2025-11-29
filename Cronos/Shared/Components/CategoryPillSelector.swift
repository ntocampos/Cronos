import SwiftData
import SwiftUI

struct CategoryPillSelector: View {
  let categories: [Category]
  @Binding var selectedCategory: Category?

  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      FormSectionHeader("Category", icon: "folder")

      FlowLayout(spacing: 10) {
        ForEach(categories) { category in
          CategoryPill(
            category: category,
            isSelected: selectedCategory?.id == category.id,
            reduceMotion: reduceMotion,
            onTap: {
              withAnimation(reduceMotion ? nil : .formBouncy) {
                selectedCategory = category
              }
            }
          )
        }
      }
    }
  }
}

private struct CategoryPill: View {
  let category: Category
  let isSelected: Bool
  let reduceMotion: Bool
  let onTap: () -> Void

  var body: some View {
    Button(action: onTap) {
      HStack(spacing: 8) {
        if !isSelected {
          Circle()
            .fill(category.color)
            .frame(width: 12, height: 12)
        }

        Text(category.name)
          .font(.subheadline)
          .fontWeight(.medium)

        if category.isDefault {
          Image(systemName: "star.fill")
            .font(.caption2)
            .foregroundStyle(isSelected ? .white.opacity(0.8) : .secondary)
        }
      }
      .foregroundStyle(isSelected ? .white : .primary)
      .padding(.horizontal, 16)
      .padding(.vertical, 10)
      .background(
        ZStack {
          if isSelected {
            Capsule()
              .fill(category.color)
              .glassEffect(in: .capsule)
          } else {
            Capsule()
              .fill(Color(.secondarySystemFill).opacity(0.3))
              .glassEffect(in: .capsule)
              .overlay(
                Capsule()
                  .strokeBorder(category.color.opacity(0.5), lineWidth: 1.5)
              )
          }
        }
      )
      .scaleEffect(isSelected ? 1.05 : 1.0)
    }
    .buttonStyle(.plain)
    .animation(reduceMotion ? nil : .formBouncy, value: isSelected)
    .accessibilityLabel("\(category.name) category")
    .accessibilityHint(isSelected ? "Selected" : "Double tap to select")
    .accessibilityAddTraits(isSelected ? .isSelected : [])
  }
}

/// A layout that arranges views in horizontal rows, wrapping to new rows as needed
struct FlowLayout: Layout {
  var spacing: CGFloat = 8

  func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
    let result = arrangeSubviews(proposal: proposal, subviews: subviews)
    return result.size
  }

  func placeSubviews(
    in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()
  ) {
    let result = arrangeSubviews(proposal: proposal, subviews: subviews)

    for (index, position) in result.positions.enumerated() {
      subviews[index].place(
        at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
        proposal: .unspecified
      )
    }
  }

  private func arrangeSubviews(proposal: ProposedViewSize, subviews: Subviews) -> ArrangementResult
  {
    let maxWidth = proposal.width ?? .infinity
    var positions: [CGPoint] = []
    var currentX: CGFloat = 0
    var currentY: CGFloat = 0
    var lineHeight: CGFloat = 0
    var totalHeight: CGFloat = 0
    var totalWidth: CGFloat = 0

    for subview in subviews {
      let size = subview.sizeThatFits(.unspecified)

      // Check if we need to wrap to next line
      if currentX + size.width > maxWidth && currentX > 0 {
        currentX = 0
        currentY += lineHeight + spacing
        lineHeight = 0
      }

      positions.append(CGPoint(x: currentX, y: currentY))
      lineHeight = max(lineHeight, size.height)
      currentX += size.width + spacing
      totalWidth = max(totalWidth, currentX - spacing)
    }

    totalHeight = currentY + lineHeight

    return ArrangementResult(
      positions: positions,
      size: CGSize(width: totalWidth, height: totalHeight)
    )
  }

  private struct ArrangementResult {
    var positions: [CGPoint]
    var size: CGSize
  }
}

#Preview {
  struct PreviewWrapper: View {
    @State private var selectedCategory: Category?

    var body: some View {
      let dataContainer = DataContainer(includeSampleMoments: true, isStoredInMemoryOnly: true)
      let categories = try! dataContainer.context.fetch(FetchDescriptor<Category>())

      VStack {
        CategoryPillSelector(
          categories: categories,
          selectedCategory: $selectedCategory
        )
        .padding()

        Spacer()
      }
      .background(Color(.systemGroupedBackground))
      .modelContainer(dataContainer.modelContainer)
    }
  }

  return PreviewWrapper()
}
