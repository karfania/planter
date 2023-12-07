////
////  MoodCalendarViewModel.swift
////  Planter
////
////  Created by Kory Arfania.
////
//
//import Foundation
//import FirebaseAuth
//
//class MoodCalendarViewModel: ObservableObject {
//    @Published var user: User?
//
//    let userViewModel = UserViewModel()
//    
//    /* Set mood for a specific date & update user's calendar */
//    func setMood(for date: Date, to mood: MoodCalendar.Mood?) {
//        self.user!.moods.calendar[Calendar.current.startOfDay(for: date)] = mood
//        userViewModel.updateUser()
//    }
//
//    /* Mood for specific date */
//    func getMood(for date: Date) -> MoodCalendar.Mood? {
//        return user!.moods.calendar[Calendar.current.startOfDay(for: date)]
//    }
//
//    /* mood for month and year */
//    func getMood(for month: Int, year: Int) -> [Date: MoodCalendar.Mood] {
//        var monthMoods: [Date: MoodCalendar.Mood] = [:]
//        for (date, mood) in user!.moods.calendar {
//            let _month = Calendar.current.component(.month, from: date)
//            let _year = Calendar.current.component(.year, from: date)
//            if _month == month && _year == year {
//                monthMoods[date] = mood
//            }
//        }
//        return monthMoods
//    }
//
//    /* Mood for year */
//    func getMood(for year: Int) -> [Date: MoodCalendar.Mood] {
//        var yearMoods: [Date: MoodCalendar.Mood] = [:]
//        for (date, mood) in user!.moods.calendar {
//            let _year = Calendar.current.component(.year, from: date)
//            if _year == year {
//                yearMoods[date] = mood
//            }
//        }
//        return yearMoods
//    }
//
//    /* Getting all moods for a user */
//    func getAllMoods() -> [Date: MoodCalendar.Mood] {
//        return user!.moods.calendar
//    }
//    
//    /* Update user's mood calendar entirely */
//    func setMoodCalendar(for user: User, to moodCalendar: MoodCalendar) {
//        self.user!.moods = moodCalendar
//        userViewModel.updateUser()
//    }
//
//    /* Remove mood for a specific date */
//    func removeMood(for date: Date) {
//        self.user!.moods.calendar[Calendar.current.startOfDay(for: date)] = nil
//        userViewModel.updateUser()
//    }
//
//}
