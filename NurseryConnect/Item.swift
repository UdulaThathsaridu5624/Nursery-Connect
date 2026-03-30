//
//  Item.swift
//  NurseryConnect
//
//  Created by Udula on 2026-03-30.
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
