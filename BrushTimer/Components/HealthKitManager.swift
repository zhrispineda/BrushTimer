//
//  HealthKitManager.swift
//  BrushTimer
//

import HealthKit
import os

class HealthKitManager: ObservableObject {
    var healthStore = HKHealthStore()
    
    func requestHealthData() {
        let toRead = HKObjectType.categoryType(forIdentifier: .toothbrushingEvent)
        let toSave = HKSampleType.categoryType(forIdentifier: .toothbrushingEvent)
        
        let readTypes: Set<HKObjectType> = [toRead!]
        let saveTypes: Set<HKSampleType> = [toSave!]
        
        guard HKHealthStore.isHealthDataAvailable() else {
            print("Health data not available")
            return
        }
        
        healthStore.requestAuthorization(toShare: saveTypes, read: readTypes) { (success, error) in
            if success {
                print("Authorization successful")
            } else {
                print("Authorization failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}
