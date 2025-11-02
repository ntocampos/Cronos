//
//  Deadline.swift
//  Cronos
//
//  Created by Moisés Neto on 11/10/25.
//

import Foundation
import SwiftData

@Model
final class Deadline: Identifiable {
  var id: UUID
  var title: String
  var notes: String?
  var date: Date

  var category: Category?

  init(title: String, notes: String? = nil, date: Date, category: Category? = nil) {
    self.id = UUID()
    self.title = title
    self.notes = notes
    self.date = date
    self.category = category
  }

  var isPast: Bool {
    date < Date()
  }

  var daysUntil: Int? {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.day], from: Date(), to: date)
    return components.day
  }

  var daysUntilText: String {
    guard let daysUntil = daysUntil else { return "Unknown" }
    if daysUntil == 0 { return "Today" }
    if daysUntil == 1 { return "Tomorrow" }
    return "\(daysUntil) day\(daysUntil == 1 ? "" : "s")"
  }
}
