//
//  HomeView.swift
//  tempPlanterViews
//
//  Created by Kory Arfania on 12/5/23.
//

import SwiftUI

struct HomeView: View {
    // @EnvironmentObject private var userViewModel: UserViewModel
    private var user = "Kory"
    @State private var isMenuExpanded = false
    
    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 20) {
                HStack {
                    Text("Welcome, \(user)!")
                        .font(.custom("Hedvig Letters Serif", size: 40))
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .padding(.top, 20)
                    
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
                                                destination: EditProfileView(),
                                                label: {
                                                    Text("Edit Profile")
                                                })
                                                .isDetailLink(false)

                                            NavigationLink(
                                                destination: LogoutView(),
                                                label: {
                                                    Text("Log Out")
                                                })
                                                .isDetailLink(false)
                                        }
                                        .listStyle(InsetGroupedListStyle())
                                    }
                    
                    
                                } //HStack
                
                
                NavigationLink(destination: GardenView()) {
                                VStack {
                                    Text("Your Garden")
                                        .font(.title)
                                        .fontWeight(.bold)
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack {
                                            // Add your square images here
                                            Image(systemName: "photo")
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                            Image(systemName: "photo")
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                            // Add more images as needed
                                        }
                                    }
                                }
                            }
                .padding()

                            NavigationLink(destination: EditGoalView()) {
                                VStack {
                                    Text("Add Activity")
                                        .font(.title)
                                        .fontWeight(.bold)
                                    // Add your progress bar here based on % completion
                                    ProgressBar(percentage: 50)
                                        .frame(height: 20)
                                }
                            }
                            .padding()

                            NavigationLink(destination: MoodCalendarView()) {
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
        }
    }


#Preview {
    HomeView()
}

