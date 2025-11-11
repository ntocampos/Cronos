//
//  Category.swift
//  Cronos
//
//  Created by Moisés Neto on 11/10/25.
//

import SwiftData
import SwiftUI

@Model
final class Category: Identifiable {
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
