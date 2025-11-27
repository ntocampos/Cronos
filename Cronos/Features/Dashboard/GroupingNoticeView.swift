//
//  GroupingNoticeView.swift
//  Cronos
//
//  Created by Assistant on 11/25/25.
//

import SwiftUI

struct GroupingNoticeView: View {
  let groupingMode: GroupingMode
  let onClear: () -> Void

  private var modeText: String {
    switch groupingMode {
    case .none: return ""
    case .byCategory: return "Category"
    case .byTimeframe: return "Timeframe"
    }
  }

  private var modeIcon: String {
    switch groupingMode {
    case .none: return ""
    case .byCategory: return "tag.fill"
    case .byTimeframe: return "calendar.circle.fill"
    }
  }

  var body: some View {
    HStack(spacing: 6) {
      Image(systemName: modeIcon)
        .font(.subheadline)
        .foregroundColor(.accentColor)

      Text("Grouped by")
        .font(.subheadline)
        .foregroundColor(.secondary)

      Text(modeText)
        .font(.subheadline)
        .fontWeight(.semibold)
        .foregroundColor(.accentColor)

      Spacer()

      Button("Clear", action: onClear)
        .font(.subheadline)
        .fontWeight(.medium)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 16)
    .padding(.vertical, 12)
    .background(
      RoundedRectangle(cornerRadius: 12)
        .fill(Color.accentColor.opacity(0.1))
    )
    .padding(.horizontal, 16)
  }
}

#Preview {
  VStack(spacing: 16) {
    GroupingNoticeView(groupingMode: .byCategory) {}
    GroupingNoticeView(groupingMode: .byTimeframe) {}
  }
}
