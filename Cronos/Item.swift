//
//  Item.swift
//  Cronos
//
//  Created by Moisés Neto on 11/10/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
