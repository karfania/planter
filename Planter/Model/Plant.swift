//
//  Plant.swift
//  Planter
//
//  Created by Kory Arfania.
//

import Foundation
import CoreLocation

// grabs different URLs returned by API for plant photos
struct PlantPhotoURLs: Codable, Hashable {
    let image_id: Int
    let license: Int
    let license_name: String
    let license_url: String
    let original_url: String
    let regular_url: String
    let medium_url: String
    let small_url: String
    let thumbnail: String
}

// PlantList: represents general information for a single plant and its information
struct PlantList: Identifiable, Hashable, Decodable {
    let id: String
    let name: String
    let cycle: String
    let watering: String
    // let bark: String
    // let leaves: String
    // let attracts: [String]
    let default_image: PlantPhotoURLs

    // adding hashing functionality
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(cycle)
        hasher.combine(watering)
        hasher.combine(default_image)
    }
}

struct PlantDetails: Identifiable, Hashable, Decodable  {
    let id: String
    let description: String
    let attracts: [String]

    // adding hashing functionality
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(description)
        hasher.combine(attracts)
    }
}

// combines general and detailed plant information for a single plant
struct Plant: Identifiable, Codable {
    let pid: String
    let id: String
    let name: String
    let cycle: String
    let watering: String
    let description: String
    let attracts: [String]
    let default_image: PlantPhotoURLs
    let location_obtained: CodableCoord

    init(pid: String = UUID().uuidString, id: String, name: String, cycle: String, watering: String, description: String, attracts: [String], default_image: PlantPhotoURLs, location_obtained: CodableCoord) {
        self.pid = pid
        self.id = id
        self.name = name
        self.cycle = cycle
        self.watering = watering
        self.description = description
        self.attracts = attracts
        self.default_image = default_image
        self.location_obtained = location_obtained
    }
}

