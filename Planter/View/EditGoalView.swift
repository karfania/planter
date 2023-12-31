//
//  EditGoalView.swift
//  tempPlanterViews
//
//  Created by Kory Arfania on 12/5/23.
//

import SwiftUI

struct EditGoalView: View {
    @ObservedObject var userViewModel: UserViewModel
    
    @State private var goalType = 0
    @State private var unitType = 0
    @State private var amountUnitsStr = ""
    @State private var amountUnits: Double = 0.0
    @State private var enteredGoal = false
    
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
            VStack{
                Text("What are your goals?")
                    .font(.custom("Hedvig Letters Serif", size: 60))
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
                        userViewModel.setDailyGoal(
                            type: goalTypes[goalType],
                            unit: unitTypes[unitType],
                            goalAmount: amountUnits,
                            progress: userViewModel.user?.dailyGoal.progress ?? 0
                        ) { result in
                        switch result {
                            case .success(let user):
                                print("Successfully updated goal")
                                enteredGoal = true
                            case .failure(let error):
                                print("Error updating goal")
                                enteredGoal = false }
                        }

                    } else {
                        // Handle the situation where goalType index is out of bounds or nil
                        print("Invalid goalType index or nil value.")
                        enteredGoal = false
                    }
                }
                
                NavigationLink(
                    destination: HomeView(userViewModel: userViewModel).navigationBarBackButtonHidden(),
                    isActive: $enteredGoal,
                    label: {
                        EmptyView()
                    })
                .padding()
                
            }
        }
        
        
        
        
        
        
    }
}
