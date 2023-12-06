//
//  LoginView.swift
//  Planter
//
//  Created by Kory Arfania on 12/5/23.
//

import SwiftUI

struct LoginView: View {
    @State private var _email = ""
    @State private var _password = ""
    @State private var isLoggedIn = false
    @State private var loginError = true
    
    @ObservedObject var userViewModel: UserViewModel
    
    var body: some View {
        
        Text("Login")
            .font(.custom("Hedvig Letters Serif", size: 60))
            .padding(.top, 100)
        
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
        
        Button("Login") {
//            // Using FireAuth login in UserViewModel to log in user
//            userViewModel.loginUser(email: _email, password: _password)
//            // Check if successful
//            if let user = userViewModel.user {
//                isLoggedIn = true
//            }
        }
            .padding()
            .foregroundColor(.white)
            .background(Color(red: 157/255, green: 193/255, blue: 131/255))
            .cornerRadius(10)
        
        NavigationLink(
            destination: HomeView(),
            isActive: $isLoggedIn,
            label: {
                EmptyView()
            })
        
            .padding()
        
        Spacer()
    }
}


//
//#Preview {
//    LoginView(userViewModel: <#UserViewModel#>)
//}
//
