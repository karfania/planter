//
//  MoodCalendarViewModel.swift
//  Planter
//
//  Created by Kory Arfania.
//

import Foundation
import FirebaseAuth

class MoodCalendarViewModel: ObservableObject {
    @Published var user: User?

    let UserViewModel = UserViewModel()
    
    /* Update user's mood calendar */
    func updateMoodCalendar(for user: User, to moodCalendar: MoodCalendar) {
        user.moods = moodCalendar
        UserViewModel.updateUser()
    }

    /* Change user's mood for a specific date */
    func changeMood(for date: Date, to mood: MoodCalendar.Mood) {
        user!.moods.setMood(for: date, to: mood)
        UserViewModel.updateUser()
    }

    /* Remove mood for a specific date */
    func removeMood(for date: Date) {
        user!.moods.setMood(for: date, to: nil)
        UserViewModel.updateUser()
    }

}
