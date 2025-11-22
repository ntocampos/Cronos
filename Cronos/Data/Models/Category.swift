//
//  Category.swift
//  Cronos
//
//  Created by Moisés Neto on 11/10/25.
//

import SwiftData
import SwiftUI

@Model
class Category: Identifiable {
  var id: UUID
  var name: String
  var colorHex: String
  var sortOrder: Int = 0

  @Relationship(deleteRule: .noAction, inverse: \Deadline.category)
  var deadlines: [Deadline]

  init(name: String, colorHex: String = "#007AFF", sortOrder: Int = 0) {
    self.id = UUID()
    self.name = name
    self.colorHex = colorHex
    self.sortOrder = sortOrder
    self.deadlines = []
  }

  var isDefault: Bool {
    let storedId = UserDefaults.standard.string(forKey: SettingsKeys.defaultCategoryId)
    return storedId == id.uuidString
  }
}

extension Category {
  static let sample = sampleData[0]
  static let personal = sampleData[1]
  static let work = sampleData[2]
  static let hobby = sampleData[3]
  static let empty = sampleData[4]

  static let sampleData = [
    Category(name: "General", colorHex: Category.DefaultColors.yellow),
    Category(name: "Personal", colorHex: Category.DefaultColors.orange),
    Category(name: "Work", colorHex: Category.DefaultColors.blue),
    Category(name: "Hobby", colorHex: Category.DefaultColors.green),
    Category(name: "Empty", colorHex: Category.DefaultColors.red),
  ]
}
