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
  var color: Color

  @Relationship(deleteRule: .nullify, inverse: \Deadline.category)
  var deadlines: [Deadline]

  init(name: String, color: Color) {
    self.id = UUID()
    self.name = name
    self.color = color
  }
}
