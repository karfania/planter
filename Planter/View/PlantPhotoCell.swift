//
//  PhotoCell.swift
//  ArfaniaKoryHW7
//
//  Created by Kory Arfania on 10/31/23.
//

import SwiftUI
import Kingfisher

/* Inspired from HW7 */
struct PlantPhotoCell: View {
    @ObservedObject var userViewModel: UserViewModel
    let plant: Plant
    
    var body: some View {
        NavigationLink(destination: PlantDetailPage(userViewModel: userViewModel, plant: plant)) {
            KFImage(URL(string: plant.default_image!.regular_url))
                .resizable()
                .aspectRatio(1,contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 50)
                .clipped()
        }
    }
}
