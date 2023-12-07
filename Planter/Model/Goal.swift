//
//  Goal.swift
//  Planter
//
//  Created by Kory Arfania.
//

import Foundation
import FirebaseFirestore

// Goal Model: represents a single daily goal and its information
struct Goal: Codable {

    // let id: String
    var type: String
    var unit: String
    var goalAmount: Double
    var progress: Double
    var completed: Bool
    var dateAssigned: String

    init(id: String = UUID().uuidString, type: String, unit: String, goalAmount: Double, progress: Double, completed: Bool, dateAssigned: String) {
        self.type = type
        self.unit = unit
        self.goalAmount = goalAmount
        self.progress = progress
        self.completed = completed
        self.dateAssigned = dateAssigned
    }
    
    // default constructor
    init() {
        self.type = "Walk"
        self.unit = "Steps"
        self.goalAmount = 0.0
        self.progress = 0.0
        self.completed = false
        self.dateAssigned = "01/01/1970"

    }
}
