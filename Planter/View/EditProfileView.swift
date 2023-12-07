//
//  EditProfileView.swift
//  tempPlanterViews
//
//  Created by Kory Arfania.
//

import SwiftUI

struct EditProfileView: View {
    @ObservedObject var userViewModel: UserViewModel
    @State var newUsername = ""
    @State var clickedDone = false
    
    
    var body: some View {
        VStack {
            Text("Edit Profile")
                .font(.custom("Hedvig Letters Serif", size: 100))
                .padding(.top, 60)
            
            TextField("Enter new username", text: $newUsername)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        Button("Change Username") {
                            // Perform the username change action here
                            if !newUsername.isEmpty {
                                // Call a function to update the username in Firestore or your data model
                                userViewModel.user?.username = newUsername
                                let userData = userViewModel.formatUserDataAndUpdate(completion: { result in
                                    switch result {
                                    case .success(let user):
                                        print("Successfully updated user data: \(user)")
                                    case .failure(let error):
                                        print("Error updating user data: \(error)")
                                    }
                                })
                                
                            }
                        }
                        .padding()
            
                    NavigationLink(
                        destination: HomeView(userViewModel: userViewModel),
                        label: {
                            Text("Edit Profile")
                        })

                        Spacer()
                    }
            
            
            
            
        }
    }

