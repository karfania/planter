//
//  LandingPage.swift
//  Planter
//
//  Created by Kory Arfania.
//

import SwiftUI

struct LandingPage: View {
    @ObservedObject var userViewModel: UserViewModel

    var body: some View {
        NavigationView {
            VStack{
                Text("Planter")
                    .foregroundStyle(Color(red: 15/255, green: 81/255, blue: 50/255))
                    .font(.custom("Hedvig Letters Serif", size: 100))
                    .padding(.top, 100)
                
                Image("landing")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .offset(y: -50)
        
                    HStack {
                        NavigationLink(destination: LoginView(userViewModel: userViewModel).navigationBarBackButtonHidden()) {
                            Text("Login")
                                .font(.title)
                                .bold()
                            
                        }
                        
                        NavigationLink(destination: SignUpView(authViewModel: userViewModel.authViewModel, userViewModel: userViewModel).navigationBarBackButtonHidden()) {
                            Text("Sign Up")
                                .font(.title)
                                .bold()
                        }
                        
                    }
                    .padding(.top, 30)
                }
                
                Spacer()
        }
        .onAppear {
            if userViewModel.user != nil {
                userViewModel.logoutUser() { result in
                    switch result {
                    case .success(_):
                        print("Successfully signed out")
              
                    case .failure(let error):
                        print("Error signing out: \(error.localizedDescription)")
         
                    }
                }
            }
        }
    }
        
}

//#Preview {
//    LandingPage()
//}
