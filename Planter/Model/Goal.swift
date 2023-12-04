//
//  Goal.swift
//  Planter
//
//  Created by Kory Arfania.
//

import Foundation

// Goal Model: represents a single daily goal and its information
struct Goal: Identifiable, Codable {
    
    enum GoalType: String, Codable {
        case walking
        case running
    }
    enum GoalUnit: String, Codable {
        case steps
        case miles
    }
    let id: String
    var type: GoalType
    var unit: GoalUnit
    var goalAmount: Double
    var progress: Double
    var completed: Bool
    let dateAssigned: Date

    init(id: String = UUID().uuidString, type: GoalType, unit: GoalUnit, goalAmount: Double, progress: Double, completed: Bool, dateAssigned: Date) {
        self.id = id
        self.type = type
        self.unit = unit
        self.goalAmount = goalAmount
        self.progress = progress
        self.completed = completed
        self.dateAssigned = dateAssigned
    }
}
