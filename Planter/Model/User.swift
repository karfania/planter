//
//  User.swift
//  Planter
//
//  Created by Kory Arfania.
//

import Foundation
import FirebaseAuth

// User Model
struct User{
    let uid: String
    var username: String
    var email: String
    var plants: [Plant] = []
    var dailyGoal: Goal
    var moods: MoodCalendar = MoodCalendar()

    init(uid: String, username: String, email: String, plants: [Plant], dailyGoal: Goal, moods: MoodCalendar) {
        self.uid = uid
        self.username = username
        self.email = email
        self.plants = plants
        self.dailyGoal = dailyGoal
        self.moods = moods
    }

    // // initialize user from firebase data
    // init?(firebaseUser: FirebaseAuth.User) {
    //     guard let name = firebaseUser.displayName,
    //           let email = firebaseUser.email else {
    //         return nil
    //     }
    //     guard let currGoal = firebaseUser.currGoal else {
    //         self.currGoal = Goal(type: .walking, unit: .steps, goalAmount: 0, progress: 0, completed: false, dateAssigned: Date())
    //     }
    //     guard let plants = firebaseUser.plants else {
    //         self.plants = []
    //     }
    //     guard let moods = firebaseUser.moods else {
    //         self.moods = MoodCalendar()
    //     }
    //     self.init(name: name, email: email)
    // }
}
