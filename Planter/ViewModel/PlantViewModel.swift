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
    @Published var plants: [Plant]

    var plantList: [PlantList]
    var plantDetails: PlantDetails

    // async function to retrieve list of plants from API
    func fetchPlantList() async {
        let url = URL(string: "\(BASE_URL)?key=\(ProcessInfo.processInfo.environment["API_KEY"])")!
        var urlRequest = URLRequest(url: url)
        //urlRequest.setValue("Client-ID \(ACCESS_KEY)", forHTTPHeaderField: "Authorization")
        
        do {
            // http request for general information
            self.isLoading = true
            let(data, _) = try await URLSession.shared.data(for: urlRequest)
            
            // decoding data
            let decodedPlantListData = try JSONDecoder().decode([PlantList].self, from: data)
            
            // set photos property
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
    }

    // async function to retrieve detailed information for a single plant from API
    func fetchPlantDetails(id: String) async {
        let url = URL(string: "\(BASE_URL_DETAILS)\(id)?key=\(ProcessInfo.processInfo.environment["API_KEY"])")!
        var urlRequest = URLRequest(url: url)
        //urlRequest.setValue("Client-ID \(ACCESS_KEY)", forHTTPHeaderField: "Authorization")
        
        do {
            // http request for detailed information
            self.isLoading = true
            let(data, _) = try await URLSession.shared.data(for: urlRequest)
            
            // decoding data
            let decodedPlantData = try JSONDecoder().decode(PlantDetails.self, from: data)
            
            // set photos property
            DispatchQueue.main.async {
                self.plants = decodedPlantData
                self.isLoading = false
            }
            
        } catch {
            print(error)
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
}
