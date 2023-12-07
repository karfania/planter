//
//  PlantViewModel.swift
//  Planter
//
//  Created by Kory Arfania.
//

import Foundation
import FirebaseFirestore

class PlantViewModel: ObservableObject {
    private let BASE_URL_LIST = "https://perenual.com/api/species-list"
    private let BASE_URL_DETAILS = "https://perenual.com/api/species/details/"

    @Published var isLoading = false
    @Published var plants: [Plant] = []

    var paginatedPlantList: PaginatedPlantList? = nil
    var plantList: [PlantList] = []
    var plantDetails: PlantDetails? = nil

    let AuthViewModel: AuthViewModel

    init(AuthViewModel: AuthViewModel) {
        self.AuthViewModel = AuthViewModel
    }

    // async function to retrieve list of plants from API
    func fetchPlantList() async -> PaginatedPlantList? {
        print(String(describing: ProcessInfo.processInfo.environment["API_KEY"]!))
        print("\(BASE_URL_LIST)?key=\(String(describing: ProcessInfo.processInfo.environment["API_KEY"]!))")
        let url = URL(string: "\(BASE_URL_LIST)?key=\(String(describing: ProcessInfo.processInfo.environment["API_KEY"]!))")!
        let urlRequest = URLRequest(url: url)
        //urlRequest.setValue("Client-ID \(ACCESS_KEY)", forHTTPHeaderField: "Authorization")
        
        do {
            // http request for general information
            self.isLoading = true
            let(data, _) = try await URLSession.shared.data(for: urlRequest)
            
            
            print(data)
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Received data: \(jsonString)")
            }
            
            // decoding data
            //let dataContainer = try JSONDecoder().decode([String: [PlantList]].self, from: data)
            let dataContainer = try JSONDecoder().decode(PaginatedPlantList.self, from: data)
            print("dataContainer \(dataContainer)")
//            if let decodedPlantListData = dataContainer["data"] {
                
                // set plantList property
            DispatchQueue.main.async { [self] in
                    //self.plantList = decodedPlantListData
                    self.paginatedPlantList = dataContainer
                print("paginatedPlantList = \(paginatedPlantList!)")
                    self.isLoading = false
                    
                }
//            }
        } catch {
            print(error)
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
        // return plantList
        return self.paginatedPlantList ?? nil
       
    }

    // async function to retrieve detailed information for a single plant from API
    func fetchPlantDetails(id: Int) async -> PlantDetails?
    {
        let url = URL(string: "\(BASE_URL_DETAILS)\(id)?key=\(String(describing: ProcessInfo.processInfo.environment["API_KEY"]))")!
        let urlRequest = URLRequest(url: url)
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

    // adding plant to user's plant list upon completing goal
    func addPlantUponGoalCompletion(plant: Plant) {
        // add plant to user's plant list
        AuthViewModel.user?.plants.append(plant)
        // convert plants data to appropriate form
        let plantDict = self.convertPlantToDict(plants: AuthViewModel.user!.plants)
        print("plant dictArray \(plantDict)")
        // update user's plant list in Firestore
        Firestore.firestore().collection("users").document(AuthViewModel.user!.uid).updateData(["plants": plantDict]) { (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Plant added to user's plant list")
            }
        }
    }

    // grab user plants from firebase
    func fetchUserPlants() -> [Plant] {
        // read from firestore
        AuthViewModel.fetchUser { result in
            switch result {
            case .success(let user):
                print("user \(user)")
                self.AuthViewModel.user = user
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        return AuthViewModel.user?.plants ?? []
    }

    // converts plant data into dictionary representation for firebase
    func convertPlantToDict(plants: [Plant]) -> [[String: Any]] {
        var dictArray: [[String: Any]] = []
        for plant in plants {
            let defaultImageDict: [String:Any] = [
                "license": plant.default_image?.license ?? "",
                 "license_name": plant.default_image?.license_name ?? "",
                 "license_url": plant.default_image?.license_url ?? "",
                 "original_url": plant.default_image?.original_url ?? "",
                 "regular_url": plant.default_image?.regular_url ?? "",
                 "medium_url": plant.default_image?.medium_url ?? "",
                 "small_url": plant.default_image?.small_url ?? "",
                 "thumbnail": plant.default_image?.thumbnail ?? ""
            ]
            
            let plantDict: [String:Any] = [
                "pid": plant.pid,
                "id": plant.id,
                "name": plant.name,
                "cycle": plant.cycle,
                "watering": plant.watering,
                "description": plant.description,
                "attracts": plant.attracts,
                "default_image": defaultImageDict,
                "location_obtained": "\(plant.location_obtained.lat), \(plant.location_obtained.long)"
            ]
            dictArray.append(plantDict)
        }
        
        return dictArray
    }
}
