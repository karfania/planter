//
//  HealthManager.swift
//  Planter
//
//  Created by Kory Arfania.
//

import Foundation
import HealthKit

/* Wrapper & manager for Core Location */
class HealthManager {
    private let healthManaager = HKHealthStore()
    
    @Published var authorizationStatus: HKAuthorizationStatus = .notDetermined
    @Published var stepCount: Double = 0.0
    @Published var distance: Double = 0.0
    
    
    init() {
        authorizeHealthKit() { (success, error) in
            if success {
                print("HealthKit authorization successful")
            } else {
                print("HealthKit authorization denied")
            }
            self.startObservingHealthData()
        }
        
        // checking auth status and authorizing if needed
        func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Void) {
            guard let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount) else {
                return
            }
            let stepType = HKObjectType.quantityType(forIdentifier: .stepCount)!
            let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
            
            let typesToRead: Set<HKObjectType> = [stepType, distanceType]
            
            healthManaager.requestAuthorization(toShare: nil, read: typesToRead) { (success, error) in
                if success {
                    print("HealthKit authorization successful")
                } else {
                    print("HealthKit authorization denied")
                }
                completion(success, error)
            }
        }
    }
    
    // observing changes in health data
    func startObservingHealthData() {
        guard HKHealthStore.isHealthDataAvailable() else {
            return
        }
        let stepType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        
        healthManaager.enableBackgroundDelivery(for: stepType, frequency: .immediate) { (success, error) in
            if success {
                print("Enabled background delivery of step count")
            } else {
                if let error = error {
                    print("Failed to enable background delivery of step count: \(error.localizedDescription)")
                }
            }
        }
        healthManaager.enableBackgroundDelivery(for: distanceType, frequency: .immediate) { (success, error) in
            if success {
                print("Enabled background delivery of distance")
            } else {
                if let error = error {
                    print("Failed to enable background delivery of distance: \(error.localizedDescription)")
                }
            }
        }
        let query = HKObserverQuery(sampleType: stepType, predicate: nil) { (query, completionHandler, error) in
            if let error = error {
                print("Failed to receive step count update: \(error.localizedDescription)")
                return
            }
            self.fetchStepCount() { result in
                switch result {
                case .success(let stepCount):
                    print("Successfully fetched step count: \(stepCount)")
                case .failure(let error):
                    print("Failed to fetch step count: \(error.localizedDescription)")
                }
            }
        }
        healthManaager.execute(query)
        let distanceQuery = HKObserverQuery(sampleType: distanceType, predicate: nil) { (query, completionHandler, error) in
            if let error = error {
                print("Failed to receive distance update: \(error.localizedDescription)")
                return
            }
            self.fetchDistance() { result in
                switch result {
                case .success(let distance):
                    print("Successfully fetched distance: \(distance)")
                case .failure(let error):
                    print("Failed to fetch distance: \(error.localizedDescription)")
                }
            }
        }
        healthManaager.execute(distanceQuery)
    }
    
    // fetching step count from health data & updating data members
    func fetchStepCount(completion: @escaping (Result<Double, Error>) -> Void) {
        let stepType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, statistics, error) in
            DispatchQueue.main.async {
                guard let statistics = statistics, let sum = statistics.sumQuantity() else {
                    print("Failed to fetch step count: \(error?.localizedDescription ?? "N/A")")
                    completion(.failure(error!))
                    return
                }
                self.stepCount = sum.doubleValue(for: HKUnit.count())
                completion(.success(self.stepCount))
            }
        }
        healthManaager.execute(query)
    }
    
    // fetching distance from health data & updating data members
    func fetchDistance(completion: @escaping (Result<Double, Error>) -> Void) {
        let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, statistics, error) in
            DispatchQueue.main.async {
                guard let statistics = statistics, let sum = statistics.sumQuantity() else {
                    print("Failed to fetch distance: \(error?.localizedDescription ?? "N/A")")
                    completion(.failure(error!))
                    return
                }
                self.distance = sum.doubleValue(for: HKUnit.mile())
                completion(.success(self.distance))
            }
        }
        healthManaager.execute(query)
    }
}
