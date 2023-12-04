//
//  PlantViewModel.swift
//  Planter
//
//  Created by Kory Arfania.
//

import Foundation

class PlantViewModel: ObservableObject {
    private let BASE_URL_LIST = "https://perenual.com/api/species-list"
    private let BASE_URL_DETAILS = "https://perenual.com/api/species/details/"

    @Published var isLoading = false
    @Published var plants: [Plant] = []

    var plantList: [PlantList] = []
    var plantDetails: PlantDetails? = nil

    // async function to retrieve list of plants from API
    func fetchPlantList() async -> [PlantList] {
        let url = URL(string: "\(BASE_URL_LIST)?key=\(String(describing: ProcessInfo.processInfo.environment["API_KEY"]))")!
        var urlRequest = URLRequest(url: url)
        //urlRequest.setValue("Client-ID \(ACCESS_KEY)", forHTTPHeaderField: "Authorization")
        
        do {
            // http request for general information
            self.isLoading = true
            let(data, _) = try await URLSession.shared.data(for: urlRequest)
            
            // decoding data
            let decodedPlantListData = try JSONDecoder().decode([PlantList].self, from: data)
            
            // set plantList property
            DispatchQueue.main.async {
                self.plantList = decodedPlantListData
                self.isLoading = false
            }
            
            
            
        } catch {
            print(error)
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
        
        // return plantList
        return plantList
    }

    // async function to retrieve detailed information for a single plant from API
    func fetchPlantDetails(id: String) async -> PlantDetails?
    {
        let url = URL(string: "\(BASE_URL_DETAILS)\(id)?key=\(String(describing: ProcessInfo.processInfo.environment["API_KEY"]))")!
        var urlRequest = URLRequest(url: url)
        //urlRequest.setValue("Client-ID \(ACCESS_KEY)", forHTTPHeaderField: "Authorization")
        
        do {
            // http request for detailed information
            self.isLoading = true
            let(data, _) = try await URLSession.shared.data(for: urlRequest)
            
            // decoding data
            let decodedPlantData = try JSONDecoder().decode(PlantDetails.self, from: data)
            
            // set plantDetails property
            DispatchQueue.main.async {
                self.plantDetails = decodedPlantData
                self.isLoading = false
            }
            
        } catch {
            print(error)
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
        
        // return plantDetail for specific plant
        return plantDetails ?? nil
    }
}
