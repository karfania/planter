//
//  UserViewModel.swift
//  Planter
//
//  Created by Kory Arfania.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import HealthKit
import CoreLocation

class UserViewModel: ObservableObject, CLLocationManagerDelegate {
    @Published var user: User?
    @Published var plants: [Plant] = []
    @Published var currGoal: Goal?
    @Published var moods: MoodCalendar?

    private let healthStore = HKHealthStore()
    private let locationManager = CLLocationManager()
    private let db = Firestore.firestore()

    let plantViewModel = PlantViewModel()
    let moodCalendarViewModel = MoodCalendarViewModel()
    

    /* Create new user & add to firebase */
    func createUser(name: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let user = authResult?.user,
                  error == nil else {
                print("Error creating user: \(error!.localizedDescription)")
                return
            }
            print("Created user: \(user)")
            self.user = User(uid: user.uid, name: name, email: email, plants: [], currGoal: Goal(type: .walking, unit: .steps, goalAmount: 0, progress: 0, completed: false, dateAssigned: Date()), moods: MoodCalendar())
            self.updateUser()
        }
    }

    /* Log into existing user profile & fetch stored information */
    func loginUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            // call getUserData to retrieve user data from Firestore upon login
            guard let user = authResult?.user,
                  error == nil else {
                print("Error logging in user: \(error!.localizedDescription)")
                return
            }
            print("Logged in user: \(user)")
            self.user = user
            self.updateUser()
            completion(nil)
        }
    }

    /* Retrieve user data from Firestore to use upon login */
    private func getUserData(uid: String, completion: @escaping (User) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { document, error in
            // ensure we retrieve user information for user with uid
            guard let document = document,
                  error == nil else {
                print("Error getting user data: \(error!.localizedDescription)")
                return
            }
            guard let user = try? document.data(as: User.self) else {
                print("Error getting user data: \(error!.localizedDescription)")
                return
            }
            completion(user)
        }
    }

    /* Update user data (general) in Firestore */
    func updateUser() {
        do {
            try db.collection("users").document(user!.uid).setData(from: user)
        } catch {
            print("Error updating user data: \(error.localizedDescription)")
        }
    }

    /* Change user's email */ 
    func changeEmail(to email: String) {
        Auth.auth().currentUser?.updateEmail(to: email) { error in
            guard error == nil else {
                print("Error changing email: \(error!.localizedDescription)")
                return
            }
            print("Changed email to: \(email)")
            self.user!.email = email
            self.updateUser()
        }
    }

    /* Change user's password */
    func changePassword(to password: String) {
        Auth.auth().currentUser?.updatePassword(to: password) { error in
            guard error == nil else {
                print("Error changing password: \(error!.localizedDescription)")
                return
            }
            print("Changed password to: \(password)")
        }
    }

    /* Change user's goal & reset progress */
    func changeGoal(to goal: Goal) {
        user!.currGoal = goal
        updateUser()
    }

    /* Change user's mood for a specific date */
    func changeMood(for date: Date, to mood: MoodCalendar.Mood) {
        moodCalendarViewModel.changeMood(for: date, to: mood)
    }

    /* Update user's goal progress/completion from HealthKit */
    func updateProgressFromHealthKit(for goal: Goal, completion: @escaping(Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(NSError(domain: "AppErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "HealthKit is not available."]))
            return
        }

        // grabbing appropriate HealthKit data type based on user's type for goal
        let type: HKQuantityType
        switch currGoal.unit {
        case .steps:
            type = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        case.miles:
            type = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        }

        // requesting authorization to read HealthKit data
        healthStore.requestAuthorization(toShare: nil, read: [type]) {success, error in
            if !success {
                completion(error ?? NSError(domain: "AppErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "HealthKit is not available."]))
                return
            }
        }

        // grabbing HealthKit data for today
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        let predicate = HKQuery.predicateForSamples(withStart: today, end: tomorrow, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) {query, result, error in
            guard let result = result,
                  let sum = result.sumQuantity() else {
                completion(error ?? NSError(domain: "AppErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "HealthKit is not available."]))
                return
            }
            // updating progress and completion status of goal
            let goalProgress = sum.doubleValue(for: HKUnit.count())
            self.currGoal.progress = goalProgress
            self.currGoal.completed = goalProgress >= self.currGoal.goalAmount
            // if goal is completed, add new plant to user's collection and update user
            if self.currGoal.completed {
                self.addPlantUponGoalCompletion(at: locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))
            }
            self.updateUser()
            completion(nil)
        }

        // executing query
        healthStore.execute(query)
    }

    /* Adding new plant to user's collection upon completion */
    func addPlantUponGoalCompletion(at location: CLLocationCoordinate2D) {
        Task {
            let retreivedPlantList = await plantViewModel.fetchPlantList()
            // checking if we don't have this plant yet, in which case add to user's collection
            if let newPlant = retreivedPlantList.first(where: { plant in
                !plants.contains(where: { $0.id == plant.id })
            }) {
                // get details for new plant
                let newPlantDetails = await plantViewModel.fetchPlantDetails(id: newPlant.id)
                let plant = Plant(id: newPlant.id, name: newPlant.name, cycle: newPlant.cycle, watering: newPlant.watering, bark: newPlantDetails.bark, leaves: newPlantDetails.leaves, attracts: newPlantDetails.attracts, default_image: newPlant.default_image, location: location)
                plants.append(plant)
                self.updateUser()
            }
        }
    }
}
