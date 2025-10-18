//
//  DeadlineGrouping.swift
//  Cronos
//
//  Created by Assistant on 18/10/25.
//

import Foundation

enum DeadlineGrouping: CaseIterable {
  case all
  case byCategory
  case byTimeframe

  var displayName: String {
    switch self {
    case .all:
      return "All"
    case .byCategory:
      return "By Category"
    case .byTimeframe:
      return "By Timeframe"
    }
  }
}

struct DeadlineGroup: Identifiable {
  let id = UUID()
  let title: String
  let deadlines: [Deadline]
}
