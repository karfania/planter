//
//  AddProgressView.swift
//  Planter
//
//  Created by Kory Arfania on 12/6/23.
//

import SwiftUI

struct AddProgressView: View {
    @ObservedObject var userViewModel: UserViewModel
    
    @State private var goalType = 0
    @State private var unitType = 0
    @State private var amountUnitsStr = ""
    @State private var amountUnits: Double = 0.0
    @State private var canGoHome = false
    
    let goalTypes = ["Walk", "Run"]
    let unitTypes = ["Steps", "Miles"]
    
    var placeholderText: String {
        switch unitTypes[unitType] {
            case "Steps":
                return "Amount of Steps"
            case "Miles":
                return "Distance"
            default:
                return "Amount of Steps"
        }
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                
                Text("Enter your activity details.")
                    .font(.custom("Hedvig Letters Serif", size: 30))
                    .padding(.top, 100)
                
                Picker("Activity", selection: $goalType) {
                    ForEach(0 ..< goalTypes.count) {
                        Text(goalTypes[$0])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                HStack {
                    
                    TextField(placeholderText, text: $amountUnitsStr)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    
                    Picker("Units", selection: $unitType) {
                        ForEach(0 ..< unitTypes.count) {
                            Text(unitTypes[$0])
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    
                }
                
                Spacer()
                
                Button("Continue") {
                    if let amountUnits = Double(amountUnitsStr) {
                        self.amountUnits = amountUnits
                        print(amountUnits)
                    } else {
                        print("Invalid input. Please enter a valid number.")
                    }
                    print("goal type idx = \(goalType), goal type = \(goalTypes[goalType])")
                    print("unit type idx = \(unitType), unit type = \(unitTypes[unitType])")
                    print("amount units str = \(amountUnitsStr), amount units = \(amountUnits)")
                    
                    // call updateGoals method and mark flag to continue as true
                    if goalType < goalTypes.count {
                        userViewModel.addUserActivityProgress (
                            type: userViewModel.user?.dailyGoal.type ?? "Walk",
                            unit: userViewModel.user?.dailyGoal.unit ?? "Steps",
                            amount: amountUnits,
                            date: Date()
                        ) { result in
                        switch result {
                            case .success(let user):
                                print("Successfully updated goal")
                                // check if they surpassed their target, in which case add a new plant to their collection
                                if userViewModel.user!.dailyGoal.progress >= userViewModel.user!.dailyGoal.goalAmount {
                                    // add plant to user's plant list
                                    userViewModel.addPlantToUserCollection()
                                }
                            canGoHome = true
                            case .failure(let error):
                                print("Error updating goal")
                            canGoHome = false }
                        }

                    } else {
                        // Handle the situation where goalType index is out of bounds or nil
                        print("Invalid goalType index or nil value.")
                        canGoHome = false
                    }
                }
                
                Button("Cancel") {
                    canGoHome = true
                }
                
                NavigationLink(
                    destination: HomeView(userViewModel: userViewModel).navigationBarBackButtonHidden(),
                    isActive: $canGoHome,
                    label: {
                        EmptyView()
                    })
                .padding()
            }
            
        }
        
        
    }
}
