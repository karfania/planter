//
//  SignUpPage.swift
//  tempPlanterViews
//
//  Created by Kory Arfania on 12/4/23.
//


import SwiftUI

struct SignUpView: View {
    @State private var _email = ""
    @State private var _password = ""
    @State private var _name = ""
    @State private var isLoggedIn = false
    
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var userViewModel: UserViewModel
    
    
    var body: some View {
        NavigationView {
            VStack{
                Text("Sign Up")
                    .font(.custom("Hedvig Letters Serif", size: 60))
                    .padding(.top, 100)
                
                TextField("Name", text: $_name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                
                TextField("Email", text: $_email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $_password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
                
                Button("Sign Up") {
                    // attempt to sign up using FireAuth
                    // authViewModel.signUp(email: _email, password: _password, username: _name) { result in
                    userViewModel.signupUser(username: _name, email: _email, password: _password) { result in
                        switch result {
                        case .success(let user):
                            // mark necessary flags as successful
                            isLoggedIn = true
                        case .failure(let error):
                            isLoggedIn = false
                            print("Failed to sign up: \(error.localizedDescription)")
                        }
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(10)
                
                if let errorMessage = userViewModel.authViewModel.error {
                    Text(errorMessage)
                        .foregroundStyle(Color(.red))
                        .padding()
                }
                
                NavigationLink(
                    destination: EditGoalView(userViewModel: userViewModel).navigationBarBackButtonHidden(),
                    isActive: $isLoggedIn,
                    label: {
                        EmptyView()
                    })
                .padding()
                
                Spacer()
            }
        }

    }
}

//#Preview {
//    SignUpView()
//}

