//
//  AuthViewModel.swift
//  Planter
//
//  Created by Kory Arfania on 12/5/23.
//

import SwiftUI
import Firebase


class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var isAuthenticated = false
    @Published var error: String?
    @Published var isLoading = false

    // checking if user is already authenticated
    init() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // self.user = User(uid: user.uid, email: user.email)
                // obtaining additional information from "users" collection in Firestore
                let userRef = Firestore.firestore().collection("users").document(user.uid)
                // getting document information from userRef
                userRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        // getting data from document
                        let data = document.data()
                        // getting username from data
                        let username = data?["username"] as? String ?? ""
                        // getting plants from data
                        let plants = data?["plants"] as? [Plant] ?? []
                        // getting dailyGoal from data
                        let dailyGoal = data?["dailyGoal"] as? Goal ?? Goal(type: "Walk", unit: "Steps", goalAmount: 0, progress: 0, completed: false, dateAssigned: self.dateAssignedFormatter(dateToFormat: Date()))
                        // getting moods from data
                        let moods = data?["moods"] as? MoodCalendar ?? MoodCalendar()
                        // setting user
                        self.user = User(uid: user.uid, username: username, email: user.email ?? "", plants: plants, dailyGoal: dailyGoal, moods: moods)
                        self.isAuthenticated = true
                    } else {
                        print("Document does not exist")
                    }
                }
                //self.isAuthenticated = true
            } else {
                self.user = nil
                self.isAuthenticated = false
            }
        }
    }
    
        func dateAssignedFormatter(dateToFormat: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.string(from: dateToFormat)
        }

    // sign in user with email and password
    // update app user object
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        self.isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            self.isLoading = false
            if let error = error {
                self.error = error.localizedDescription
                completion(.failure(error))
            } else {
                // getting additional information from "users" collection in Firestore
                let userRef = Firestore.firestore().collection("users").document(result!.user.uid)
                // getting document information from userRef
                userRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        // getting data from document
                        let data = document.data()
                        // getting username from data
                        let username = data?["username"] as? String ?? ""
                        // getting plants from data
                        let plants = data?["plants"] as? [Plant] ?? []
                        // getting dailyGoal from data
                        let dailyGoal = data?["dailyGoal"] as? Goal ?? Goal(type: "Walk", unit: "Steps", goalAmount: 0, progress: 0, completed: false, dateAssigned: self.dateAssignedFormatter(dateToFormat: Date()))
                        // getting moods from data
                        let moods = data?["moods"] as? MoodCalendar ?? MoodCalendar()
                        // setting user
                        self.user = User(uid: result?.user.uid ?? "", username: username, email: result?.user.email ?? "", plants: plants, dailyGoal: dailyGoal, moods: moods)
                        self.isAuthenticated = true
                        // marking success
                        completion(.success(self.user!))
                    } else {
                        print("Document does not exist")
                    }
                }
            }
        }
    }

    // sign up user with email, password, and username
    // create user document in Firestore
    // update app user object
    func signUp(email: String, password: String, username: String, completion: @escaping (Result<User, Error>) -> Void) {
        self.isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            self.isLoading = false
            if let error = error {
                self.error = error.localizedDescription
                completion(.failure(error))
            } else {
                //self.user = User(uid: result?.user.uid, username: username, email: result?.user.email, plants: [], dailyGoal: Goal(), moods: MoodCalendar())
                guard let uid = result?.user.uid else { return }
                // adding user to "users" collection in Firestore
                let userRef = Firestore.firestore().collection("users").document(uid)
                // setting user data, formatting as dictionary beforehand

                let userData = [
                    "uid": uid,
                    "username": username,
                    "email": email,
                    "plants":[],
                    "dailyGoal": [
                        "type": "walking",
                        "unit": "steps",
                        "goalAmount": 0,
                        "progress": 0,
                        "completed": false,
                        "dateAssigned": Date()
                    ],
                    "moods": [:]
                ] as [String : Any]


                //userRef.setData(["username": username, "email": result?.user.email ?? "", "plants": [], "dailyGoal": Goal(type: .walking, unit: .steps, goalAmount: 0, progress: 0, completed: false, dateAssigned: Date()), "moods": MoodCalendar()]) { (error) in
                userRef.setData(userData) { (error) in   
                    if let error = error {
                        // write error
                        self.error = error.localizedDescription
                        completion(.failure(error))
                    } else {
                        // no error
                        let newUser = User(uid: result?.user.uid ?? "", username: username, email: result?.user.email ?? "", plants: [], dailyGoal: Goal(type: "Walk", unit: "Steps", goalAmount: 0, progress: 0, completed: false, dateAssigned: self.dateAssignedFormatter(dateToFormat: Date())), moods: MoodCalendar())
                        self.user = newUser
                        self.isAuthenticated = true
                        completion(.success(newUser))
                    }
                }
            }
        }
    }

    // sign out
    func signOut(completion: @escaping (Result<Bool, Error>) -> Void) {
        self.isLoading = true
        do {
            try Auth.auth().signOut()
            self.isLoading = false
            self.user = nil
            self.isAuthenticated = false
            completion(.success(true))
        } catch {
            self.error = error.localizedDescription
            completion(.failure(error))
        }
    }

    // fetching user data from Firestore
    func fetchUser(completion: @escaping (Result<User, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userRef = Firestore.firestore().collection("users").document(uid)
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // getting data from document
                let data = document.data()
                // getting username from data
                let username = data?["username"] as? String ?? ""
                // getting plants from data
                let plants = data?["plants"] as? [Plant] ?? []
                // getting dailyGoal from data
                var dailyGoal = Goal(type: "Walk", unit: "Steps", goalAmount: 0, progress: 0, completed: false, dateAssigned: self.dateAssignedFormatter(dateToFormat: Date()))
               
                if let dailyGoalData = data?["dailyGoal"] as? [String: Any],
                
                let jsonData = try? JSONSerialization.data(withJSONObject: dailyGoalData),
                   let dailyGoal = try? JSONDecoder().decode(Goal.self, from: jsonData) {
                    
                    // Successfully casted to Goal
                    print(dailyGoal)
                    let moods = data?["moods"] as? MoodCalendar ?? MoodCalendar()
                    // setting user
                    self.user = User(uid: uid, username: username, email: Auth.auth().currentUser?.email ?? "", plants: plants, dailyGoal: dailyGoal, moods: moods)
                    self.isAuthenticated = true
                    completion(.success(self.user!))
                } else {
                    // Failed to cast to Goal
                    print("Failed to cast dailyGoal to Goal")
                    //let dailyGoal = Goal(type: "Walk", unit: "Steps", goalAmount: 0, progress: 0, completed: false, dateAssigned: Date())
                }
                
                
            } else {
                print("Document does not exist")
                completion(.failure(error!))
            }
        }
    }

    // updating user data in Firestore
    func updateUserData(user: User, userData: [String: Any], completion: @escaping (Result<User, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userRef = Firestore.firestore().collection("users").document(uid)
        
        userRef.updateData(userData) { (error) in
            if let error = error {
                // write error
                self.error = error.localizedDescription
                completion(.failure(error))
            } else {
                // no error
                self.user?.username = user.username
                self.user?.email = user.email
                self.user?.plants = user.plants
                self.user?.dailyGoal = user.dailyGoal
                self.user?.moods = user.moods
                completion(.success(self.user!))
            }
        }
    }
    
    
}
