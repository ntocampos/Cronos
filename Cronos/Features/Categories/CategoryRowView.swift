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

  var body: some View {
    HStack {
      Circle()
        .fill(category.color)
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
  VStack {
    CategoryRowView(category: Category.work)
    CategoryRowView(category: Category.personal)
    CategoryRowView(category: Category.empty)
  }
  .sampleDataContainer()
}
