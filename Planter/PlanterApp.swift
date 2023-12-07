//
//  PlanterApp.swift
//  Planter
//
//  Created by Kory Arfania on 12/2/23.
//

import SwiftUI
import FirebaseCore


/* Code from FireBase initialization */
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct PlanterApp: App {
    
    // injecting UserViewModel for persistence
    // @StateObject private var userViewModel = UserViewModel()
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate



    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}
