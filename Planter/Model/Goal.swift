//
//  Goal.swift
//  Planter
//
//  Created by Kory Arfania.
//

import Foundation

// Goal Model: represents a single daily goal and its information
struct Goal: Identifiable, Codable, Decodable {
    enum GoalType {
        case walking
        case running
    }
    enum GoalUnit {
        case steps
        case miles
    }
    let gid: String = UUID().uuidString
    let type: GoalType
    let unit: GoalUnit
    let goalAmount: Double
    let progress: Double
    let completed: Bool
    let dateAssigned: Date

    init(type: GoalType, unit: GoalUnit, goalAmount: Double, progress: Double, completed: Bool, dateAssigned: Date) {
        self.type = type
        self.goalAmount = goalAmount
        self.progress = progress
        self.completed = completed
        self.dateAssigned = dateAssigned
    }
}
