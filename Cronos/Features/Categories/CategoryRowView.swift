//
//  CategoryRowView.swift
//  Cronos
//
//  Created by Moisés Neto on 11/10/25.
//

import SwiftData
import SwiftUI

struct CategoryRowView: View {
  let category: Category
  private let cornerRadius: CGFloat = 32

  var body: some View {
    HStack(spacing: 16) {
      Circle()
        .fill(category.color)
        .frame(width: 16, height: 16)

      VStack(alignment: .leading, spacing: 2) {
        HStack(spacing: 6) {
          Text(category.name)
            .font(.headline)

          if category.isDefault {
            Text("Default")
              .font(.caption2)
              .fontWeight(.medium)
              .foregroundStyle(.secondary)
              .padding(.horizontal, 6)
              .padding(.vertical, 2)
              .background(Color.secondary.opacity(0.15))
              .clipShape(Capsule())
          }
        }
      }

      Spacer()

      // Number badge
      ZStack {
        Circle()
          .fill(category.color.opacity(0.2))
          .frame(width: 32, height: 32)
          .glassEffect()

        Text("\(category.deadlines.count)")
          .font(.subheadline)
          .fontWeight(.semibold)
          .foregroundColor(category.color)
      }
    }
    .padding(.vertical)
    .padding(.horizontal)
    .background(
      LinearGradient(
        gradient: Gradient(colors: [
          Color(.systemBackground),
          category.color.opacity(0.15),
        ]),
        startPoint: .leading,
        endPoint: .trailing
      )
    )
    .clipShape(
      RoundedRectangle(cornerRadius: cornerRadius)
    )
    .glassEffect()
  }
}

#Preview {
  VStack {
    CategoryRowView(category: Category.work)
    CategoryRowView(category: Category.personal)
    CategoryRowView(category: Category.empty)
  }
  .padding()
  .sampleDataContainer()
}
