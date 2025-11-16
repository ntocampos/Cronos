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

  @Relationship(deleteRule: .nullify, inverse: \Deadline.category)
  var deadlines: [Deadline]

  init(name: String, colorHex: String = "#007AFF", sortOrder: Int = 0) {
    self.id = UUID()
    self.name = name
    self.colorHex = colorHex
    self.sortOrder = sortOrder
    self.deadlines = []
  }
}

extension Category {
  static let sample = sampleData[0]
  static let personal = sampleData[1]
  static let work = sampleData[2]
  static let hobby = sampleData[3]
  static let empty = sampleData[4]

  static let sampleData = [
    Category(name: "General", colorHex: Color.yellow.opacity(0.8).toHex()),
    Category(name: "Personal", colorHex: Color.orange.opacity(0.8).toHex()),
    Category(name: "Work", colorHex: Color.blue.opacity(0.8).toHex()),
    Category(name: "Hobby", colorHex: Color.green.opacity(0.8).toHex()),
    Category(name: "Empty", colorHex: Color.pink.opacity(0.8).toHex()),
  ]
}
