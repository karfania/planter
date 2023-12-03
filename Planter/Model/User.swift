//
//  User.swift
//  Planter
//
//  Created by Kory Arfania on 12/2/23.
//

import Foundation
import FirebaseAuth

// User Model
struct User: Identifiable {
    let id = UUID()
    var name: String
    var email: String
    var plants: [Plant] = []
    var currGoal: Goal
    var moods: MoodCalendar = MoodCalendar()

    init(name: String, email: String) {
        self.name = name
        self.email = email
    }

    // initialize user from firebase data
    init?(firebaseUser: FirebaseAuth.User) {
        guard let name = firebaseUser.displayName,
              let email = firebaseUser.email else {
            return nil
        }
        guard let currGoal = firebaseUser.currGoal else {
            self.currGoal = Goal(type: .walking, unit: .steps, goalAmount: 0, progress: 0, completed: false, dateAssigned: Date())
        }
        guard let plants = firebaseUser.plants else {
            self.plants = []
        }
        guard let moods = firebaseUser.moods else {
            self.moods = MoodCalendar()
        }
        self.init(name: name, email: email)
    }
}
