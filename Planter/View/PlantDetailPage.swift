//
//  PhotoDetailPage.swift
//  ArfaniaKoryHW7
//
//  Created by Kory Arfania on 11/4/23.
//

import SwiftUI
import UIKit
import PDFKit

/* Inspired from HW7 */
struct PlantDetailPage: View {
    @ObservedObject var userViewModel: UserViewModel
    let plant: Plant
    
    var body: some View {
        VStack {
            Text("\(plant.name)")
                .font(.custom("Hedvig Letters Serif", size: 100))
                .padding(.top, 40)
            
            // detailed image
            PlantDetailView(url: plant.default_image!.regular_url)
            
            // different facts about the plant based on metadata
            Text("Obtained at: \(plant.location_obtained.lat), \(plant.location_obtained.long)")
            Text("Obtained on: \(userViewModel.user?.dailyGoal.dateAssigned ?? "")")
            Text("Cycle: \(plant.cycle)")
            Text("Watering: \(plant.watering)")
        }
    }
}
