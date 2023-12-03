import Foundation

// MoodCalendar Model: represents a user's mood calendar, with emojis assigned to mood per day
struct MoodCalendar {
    enum Mood: String {
        case happy = "😄"
        case sad = "😢"
        case neutral = "😐"
        case excited = "😃"
        case angry = "😡"
    }

    private var calendar: [Date: Mood] = [:]

    mutating func setMood(for date: Date, to mood: Mood) {
        calendar[date.startOfDay] = mood
    }

    // mood for specific date
    func getMood(for date: Date) -> Mood? {
        return calendar[date.startOfDay]
    }

    // mood for month and year
    func getMood(for month: Int, year: Int) -> [Date: Mood] {
        var monthMoods: [Date: Mood] = [:]
        for (date, mood) in calendar {
            if date.month == month && date.year == year {
                monthMoods[date] = mood
            }
        }
        return monthMoods
    }

    // mood for year
    func getMood(for year: Int) -> [Date: Mood] {
        var yearMoods: [Date: Mood] = [:]
        for (date, mood) in calendar {
            if date.year == year {
                yearMoods[date] = mood
            }
        }
        return yearMoods
    }

    // all moods
    func getAllMoods() -> [Date: Mood] {
        return calendar
    }
}