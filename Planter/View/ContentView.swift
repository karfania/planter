//
//  ContentView.swift
//  Planter
//
//  Created by Kory Arfania.
//

import SwiftUI

struct ContentView: View {
    //@StateObject var authViewModel = AuthViewModel()
    @StateObject var userViewModel: UserViewModel = UserViewModel(authViewModel: AuthViewModel(), plantViewModel: PlantViewModel(AuthViewModel: AuthViewModel()), locationManager: LocationManager(), healthManager: HealthManager())
    
//    init() {
//        _userViewModel = StateObject(wrappedValue: UserViewModel(authViewModel: authViewModel, plantViewModel: plantViewModel))
//    }
    
    var body: some View {
        VStack {
            LandingPage(userViewModel: userViewModel)
        }
    }
}

#Preview {
    ContentView()
}
