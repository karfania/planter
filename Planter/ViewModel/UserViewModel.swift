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
import Combine

class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var plants: [Plant]?
    @Published var isLoading = false

    private var cancellables: Set<AnyCancellable> = []

    let authViewModel: AuthViewModel
    let plantViewModel: PlantViewModel
    let locationManager: LocationManager
    let healthManager: HealthManager
    
    // to populate firebase
    func formatDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date)
    }
    
    // for certain logic checks
    func dateStringToDateObj(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.date(from: date)!
    }
    
    // inject necessary ViewModels
    init(authViewModel: AuthViewModel, plantViewModel: PlantViewModel, locationManager: LocationManager, healthManager: HealthManager) {
        self.authViewModel = authViewModel
        self.plantViewModel = plantViewModel
        self.locationManager = locationManager
        self.healthManager = healthManager

        // observing changes to AuthViewModel's authentication status, and updating user accordingly
        authViewModel.$isAuthenticated
            .receive(on: DispatchQueue.main)
            .sink { isAuthenticated in
                if isAuthenticated {
                    self.user = authViewModel.user
                    self.plants = self.user!.plants
                } else {
                    self.user = nil
                }
            }
            .store(in: &cancellables)

        // self.user = authViewModel.user
    }

    // user sign in using authViewModel implementation
    func loginUser(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        authViewModel.signIn(email: email, password: password) { result in
            switch result {
            case .success(let user):
//                let newUser = user
                // getting additional information for user
                self.authViewModel.fetchUser() { result in
                    switch result {
                    case .success(let user):
                        let newUser = user
                        self.user = newUser
                        print("logged in user daily goal info: \(newUser.dailyGoal)")
                        completion(.success(newUser))
                        
                    case .failure(let error):
                        print("Could not log in \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                print("Could not log in \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    // user sign out using authViewModel implementation
    func logoutUser(completion: @escaping (Result<Bool, Error>) -> Void) {
        authViewModel.signOut() { result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let error):
                print("Could not log out \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    // user signup using authViewModel implementation
    func signupUser(username: String, email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        authViewModel.signUp(email: email, password: password, username: username) { result in
            switch result {
            case .success(let user):
                let newUser = user
                self.user = newUser
                self.plants = []
                completion(.success(newUser))
            case .failure(let error):
                print("Could not log in \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    // setting user's daily goal
    func setDailyGoal(type: String, unit: String, goalAmount: Double, progress: Double?, completion: @escaping (Result<User, Error>) -> Void) {
        self.user!.dailyGoal = Goal(type: type, unit: unit, goalAmount: goalAmount, progress: progress ?? 0, completed: false, dateAssigned: authViewModel.dateAssignedFormatter(dateToFormat: Date()))
        self.formatUserDataAndUpdate() { result in
            switch result {
                case .success(let user):
                    print("Successfully updated goal")
                    completion(.success(user))
                case .failure(let error):
                    print("Error updating goal")
                    completion(.failure(error))
            }
        }
    }

    // fetching new plant using API and adding to user's collection
    func addPlantToUserCollection() {
        Task {
            do {
                if let retrievedPlantList = await plantViewModel.fetchPlantList() {
                    // checking if we don't have this plant yet, in which case add to user's collection
                    guard let newPlant = retrievedPlantList.data.first(where: { plant in
                        !user!.plants.contains(where: { $0.id == plant.id })
                        
                    }) else {
                        print("Error: No new plant found.")
                        return
                    }
                    // get details for new plant
                    print("New plant for user to save: \(newPlant)")
                    if let newPlantDetails = await plantViewModel.fetchPlantDetails(id: newPlant.id) {
                        let plant = Plant(id: newPlant.id, name: newPlant.common_name, cycle: newPlant.cycle, watering: newPlant.watering, description: newPlantDetails.description, attracts: newPlantDetails.attracts, default_image: newPlant.default_image!, location_obtained: CodableCoord(locationManager.location ?? CLLocationCoordinate2D(latitude: 34.02116, longitude: -118.287132)))
                        //                    let plant = Plant(id: newPlant.id, name: newPlant.name, cycle: newPlant.cycle, watering: newPlant.watering, description: newPlantDetails.description, attracts: newPlantDetails.attracts, default_image: newPlant.default_image, location_obtained: CodableCoord(CLLocationCoordinate2D(latitude: 0, longitude: 0)))
                        self.user?.plants.append(plant)
                        self.plants!.append(plant)
                        plantViewModel.addPlantUponGoalCompletion(plant: plant)
                        print("user's plant collection now with details: \(self.user!.plants) ")
                        //self.updateUser()
                        return
                    }
                    // plant has no details, leave blank
                    let plant = Plant(id: newPlant.id, name: newPlant.common_name, cycle: newPlant.cycle, watering: newPlant.watering, description: "", attracts: [], default_image: newPlant.default_image!, location_obtained: CodableCoord(locationManager.location ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)))
                    //                let plant = Plant(id: newPlant.id, name: newPlant.name, cycle: newPlant.cycle, watering: newPlant.watering, description: "", attracts: [], default_image: newPlant.default_image, location_obtained: CodableCoord(CLLocationCoordinate2D(latitude: 0, longitude: 0)))
                    // call plantViewModel to update plant details
                    plantViewModel.addPlantUponGoalCompletion(plant: plant)
                    self.user?.plants.append(plant)
                    self.plants!.append(plant)
                    print("user's plant collection now without details: \(self.user!.plants) ")
                } else {
                    print("Could not retrieve plant list")
                }
            }
        }
    }
    
    // adding activity progress to user profile upon manual entry
    func addUserActivityProgress(type: String, unit: String, amount: Double, date: Date, completion: @escaping (Result<User, Error>) -> Void) {
        // check if user has daily goal
        if user!.dailyGoal.type == type && user!.dailyGoal.unit == unit {
            // check if date is today
            if Calendar.current.isDateInToday(date) {
                // check if amount is greater than 0
                if amount > 0 {
                    // check if amount is less than goal amount
              
                        // update user's daily goal progress
                        user!.dailyGoal.progress += amount
                        // update user's daily goal completion status
                        user!.dailyGoal.completed = user!.dailyGoal.progress >= user!.dailyGoal.goalAmount
                        // (date not updated since it must be the same day for the goal)
                        // update user's data in Firestore
                        self.formatUserDataAndUpdate() { result in
                            switch result {
                                case .success(let user):
                                    print("Successfully updated user data")
                                    completion(.success(user))
                                case .failure(let error):
                                    print("Error updating user data")
                                    completion(.failure(error))
                            }
                        }
                
                } else {
                    print("Error: Amount entered is less than or equal to 0.")
                }
            } else {
                print("Error: Date entered is not today.")
            }
        } else {
            print("Error: User does not have a daily goal of type \(type) and unit \(unit).")
        }
    }
    
    // updating user activity progress based on HealthKit data
    func updateProgressFromHealthKit() {
        // check if user has daily goal
        if user!.dailyGoal.unit == "Steps" {
            // check if date is today
            var dateStr = user!.dailyGoal.dateAssigned
            if Calendar.current.isDateInToday(self.dateStringToDateObj(date: dateStr)) {
                // check if amount is greater than 0
                if user!.dailyGoal.progress > 0 {
                
                        // update user's daily goal progress
                        healthManager.fetchStepCount() { result in
                            switch result {
                            case .success(let steps):
                                self.user!.dailyGoal.progress = steps
                                // update user's daily goal completion status
                                self.user!.dailyGoal.completed = self.user!.dailyGoal.progress >= self.user!.dailyGoal.goalAmount
                                // (date not updated since it must be the same day for the goal)
                                // update user's data in Firestore
                                self.formatUserDataAndUpdate() { result in
                                    switch result {
                                        case .success(let user):
                                            print("Successfully updated user data")
                                        case .failure(let error):
                                            print("Error updating user data")
                                    }
                                }
                            case .failure(let error):
                                print("Error getting steps: \(error.localizedDescription)")
                            }
                        }
                 
                } else {
                    print("Error: User has not made any progress towards their daily goal.")
                }
            } else {
                print("Error: Date entered is not today.")
            }
        } else {
            // query for distance and check if user hit daily goal
            // check if date is today
            var dateStr = user!.dailyGoal.dateAssigned
            if Calendar.current.isDateInToday(self.dateStringToDateObj(date: dateStr)) {
                // check if amount is greater than 0
                if user!.dailyGoal.progress > 0 {
                
                        // update user's daily goal progress
                        healthManager.fetchDistance() { result in
                            switch result {
                            case .success(let distance):
                                self.user!.dailyGoal.progress = distance
                                // update user's daily goal completion status
                                self.user!.dailyGoal.completed = self.user!.dailyGoal.progress >= self.user!.dailyGoal.goalAmount
                                // (date not updated since it must be the same day for the goal)
                                // update user's data in Firestore
                                self.formatUserDataAndUpdate() { result in
                                    switch result {
                                        case .success(let user):
                                            print("Successfully updated user data")
                                        case .failure(let error):
                                            print("Error updating user data")
                                    }
                                }
                            case .failure(let error):
                                print("Error getting distance: \(error.localizedDescription)")
                            }
                        }
                 
                } else {
                    print("Error: User has not made any progress towards their daily goal.")
                }
            } else {
                print("Error: Date entered is not today.")
            }
            
        }
    }
    
    

    // formatting user's data to be stored in Firestore
    func formatUserDataAndUpdate(completion: @escaping (Result<User, Error>) -> Void) {
        let userData = [
            "uid": user!.uid,
            "username": user!.username,
            "email": user!.email,
            "plants":
                plantViewModel.convertPlantToDict(plants: user!.plants) as [[String : Any]]
                
            ,
            "dailyGoal": [
                "type": user!.dailyGoal.type,
                "unit": user!.dailyGoal.unit,
                "goalAmount": user!.dailyGoal.goalAmount,
                "progress": user!.dailyGoal.progress,
                "completed": user!.dailyGoal.completed,
                "dateAssigned": user!.dailyGoal.dateAssigned
            ],
            "moods": [:]
        ] as [String : Any]

        authViewModel.updateUserData(user: self.user!, userData: userData) { result in
            switch result {
            case .success(let user):
                self.user = user
                completion(.success(user))
            case .failure(let error):
                print("Could not update user data \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}
