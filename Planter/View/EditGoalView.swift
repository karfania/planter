//
//  EditGoalView.swift
//  tempPlanterViews
//
//  Created by Kory Arfania on 12/5/23.
//

import SwiftUI

struct EditGoalView: View {
    @State private var goalType = 0
    @State private var unitType = 0
    @State private var amountUnits = ""
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
                    
                    TextField(placeholderText, text: $amountUnits)
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
                    // validate entries, then:
                    enteredGoal = true
                }
                
                NavigationLink(
                    destination: HomeView(),
                    isActive: $enteredGoal,
                    label: {
                        EmptyView()
                    })
                .isDetailLink(false)
                .padding()
                
            }
        }
        
        
        
        
        
        
    }
}


#Preview {
    EditGoalView()
}
