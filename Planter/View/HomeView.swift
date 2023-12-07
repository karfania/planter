//
//  HomeView.swift
//  tempPlanterViews
//
//  Created by Kory Arfania on 12/5/23.
//

import SwiftUI

struct HomeView: View {
    // @EnvironmentObject private var userViewModel: UserViewModel
    @ObservedObject var userViewModel: UserViewModel
    @State private var isMenuExpanded = false
    @State private var isShowingEditProfile = false
    @State private var isShowingEditGoal = false
    @State private var isShowingEditMood = false
    @State private var isShowingEditPlant = false
    @State private var isLoggedOut = false
    @State private var locationPermissionDenied = false
//    @State private var plants: [Plant] = []
    
    
    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 20) {
                
             
                NavigationLink(
                    destination: LandingPage(userViewModel: userViewModel).navigationBarBackButtonHidden(),
                    isActive: $isLoggedOut,
                    label: {
                        EmptyView()
                    }) 
                
                HStack {
                    Text("Welcome, \(userViewModel.user?.username ?? "")!")
                        .font(.custom("Hedvig Letters Serif", size: 40))
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .padding(.top, 20)
                    
                    // collapsable side menu for logout and user info edit nav
                    Button(action: {
                        withAnimation {
                            isMenuExpanded.toggle()
                        }
                    }) {
                        Image(systemName: "text.alignleft")
                            .foregroundColor(.primary)
                            .font(.title)
                    }
                    .padding()
                    .padding(.top, 20)

                    if isMenuExpanded {
                        List {
                            NavigationLink(
                                destination: EditProfileView(userViewModel: userViewModel),
                                label: {
                                    Text("Edit Profile")
                                })

                            Button(action: {
                                isLoggedOut = true
                            }, label: {
                                Text("Log Out")
                            })

                            
                        }
                        .listStyle(InsetGroupedListStyle())
                    }
                } //HStack
                
                
                NavigationLink(destination: GardenView(userViewModel: userViewModel)) {
                    VStack {
                        Text("Your Garden")
                            .font(.title)
                            .fontWeight(.bold)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                // Check if plants is nil or empty
                                let plants = userViewModel.plantViewModel.fetchUserPlants()
                                if !plants.isEmpty {
                                    ForEach(plants, id: \.id) { plant in
                                        Text("Plant ID: \(plant.id)")
                                        NavigationLink(destination: PlantDetailPage(userViewModel: userViewModel, plant: plant)) {
                                            PlantPhotoCell(userViewModel: userViewModel, plant: plant)
                                        }
                                    }
                                } else {
                                    Text("You have no plants yet!")
                                }
                            }
                        }
                    }
                    .padding()
                }

                NavigationLink(destination: EditGoalView(userViewModel: userViewModel).navigationBarBackButtonHidden()) {
                    VStack {
                        Text("Change Goal")
                            .font(.title)
                            .fontWeight(.bold)
                        // calculate progress bar percentage, preventing divide by 0 error
                        if userViewModel.user!.dailyGoal.goalAmount == 0 {
                            Text("Percentage complete = 0")
                            ProgressBar(percentage: 0)
                                .frame(height: 20)
                        } else {
                            let percentage = (userViewModel.user!.dailyGoal.progress / userViewModel.user!.dailyGoal.goalAmount) * 100
                            Text("Progress: \(String(format: "%.1f", userViewModel.user!.dailyGoal.progress)) \(userViewModel.user!.dailyGoal.unit)")
                            Text("Goal: \(String(format: "%.1f", userViewModel.user!.dailyGoal.goalAmount)) \(userViewModel.user!.dailyGoal.unit)")
                            Text("\(String(format: "%.1f", percentage))% complete")
                            
                            ProgressBar(percentage: percentage)
                                .frame(height: 20)
                        }
                    }
                }
                .padding()
                
                NavigationLink(destination: AddProgressView(userViewModel: userViewModel).navigationBarBackButtonHidden()) {
                    VStack {
                        Text("Add Activity")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                }
                .padding()

                NavigationLink(destination: MoodCalendarView(userViewModel: userViewModel)) {
                    VStack {
                        Text("How was today?")
                            .font(.title)
                            .fontWeight(.bold)
                        HStack {
                            // Add your emoji views here (happy, neutral, sad)
                            Text("😊")
                                .font(.system(size: 50))
                            Text("😐")
                                .font(.system(size: 50))
                            Text("😞")
                                .font(.system(size: 50))
                        }
                    }
                }
                .padding()

                Spacer()
                         
            } // VStack 
        }
        .onAppear {
            // checking for location auth upon loading view
            userViewModel.locationManager.checkLocationAuthorization()
            locationPermissionDenied = userViewModel.locationManager.isAllowed
            
//            // if user completed goal, add plant
//            if userViewModel.user!.dailyGoal.progress >= userViewModel.user!.dailyGoal.goalAmount {
//                // add plant to user's plant list
//                userViewModel.addPlantToUserCollection()
//            }
            
//            // fetch plant info for user
//            plants = userViewModel.plantViewModel.fetchUserPlants()
            
            
           
        } .alert(isPresented: $locationPermissionDenied, content: {
            Alert(
                title: Text("Location Access Denied"),
                message: Text("Please enable location access in settings to track where you obtained your plants!"),
                primaryButton: .default(Text("Open Settings"), action: {
                    // Open app settings
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
                }),
                secondaryButton: .cancel()
            )
        })
    }
}

