//
//  CompletedFilterNoticeView.swift
//  Cronos
//
//  Created by Assistant on 11/26/25.
//

import SwiftUI

struct CompletedFilterNoticeView: View {
  let onClear: () -> Void

  var body: some View {
    HStack(spacing: 6) {
      Image(systemName: "checkmark.circle.fill")
        .font(.subheadline)
        .foregroundColor(.accentColor)

      Text("Showing")
        .font(.subheadline)
        .foregroundColor(.secondary)

      Text("Completed")
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
    CompletedFilterNoticeView {}
  }
}
