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
                    // Simulate sign up logic
                    Text("signed up!")
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(10)
                
                NavigationLink(
                    destination: EditGoalView(),
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

#Preview {
    SignUpView()
}

