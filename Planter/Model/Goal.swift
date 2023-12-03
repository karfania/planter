import Foundation

// Goal Model: represents a single daily goal and its information
struct Goal: Identifiable {
    enum GoalType {
        case walking
        case running
    }
    enum GoalUnit {
        case steps
        case miles
    }
    let id: UUID = UUID()
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