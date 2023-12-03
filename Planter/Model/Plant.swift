//
//  Plant.swift
//  Planter
//
//  Created by Kory Arfania on 12/2/23.
//

import Foundation

// Plant Model: represents a single plant and its information
struct Plant: Identifiable, Hashable {
    let id: UUID = UUID()
    let name: String
    let cycle: String
    let watering: String
    let image: String
    let bark: String
    let leaves: String
    let attracts: [String]

    // adding hashing functionality
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(cycle)
        hasher.combine(watering)
        hasher.combine(image)
        hasher.combine(bark)
        hasher.combine(leaves)
        hasher.combine(attracts)
    }





}
