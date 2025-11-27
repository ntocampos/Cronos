//
//  GroupHeaderView.swift
//  Cronos
//
//  Created by Assistant on 11/25/25.
//

import SwiftUI

struct GroupHeaderView: View {
  let title: String
  let count: Int
  let color: Color?

  @AppStorage(SettingsKeys.deadlineDensity) private var deadlineDensity: DeadlineDensity = .detailed

  var body: some View {
    HStack(spacing: 8) {
      // Color indicator
      if let color = color {
        Circle()
          .fill(color)
          .frame(width: 12, height: 12)
      }

      // Title and count
      Text(title)
        .font(.headline)
        .fontWeight(.semibold)

      Text("(\(count))")
        .font(.subheadline)
        .foregroundColor(.secondary)

      Spacer()
    }
    .padding(.vertical, 8)
    .textCase(nil)
    .animation(.bouncy, value: deadlineDensity)
  }
}

#Preview {
  VStack(alignment: .leading, spacing: 16) {
    GroupHeaderView(title: "Work", count: 5, color: .blue)
    GroupHeaderView(title: "Personal", count: 3, color: .green)
    GroupHeaderView(title: "Next 7 days", count: 2, color: .red)
    GroupHeaderView(title: "No Color", count: 1, color: nil)
  }
  .padding()
}
