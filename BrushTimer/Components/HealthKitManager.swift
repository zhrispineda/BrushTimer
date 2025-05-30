//
//  HealthKitManager.swift
//  BrushTimer
//

import HealthKit
import os

@Observable class HealthKitManager {
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
    
    func saveToothbrushingData(startDate: Date, endDate: Date) {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("Health data not available")
            return
        }
        
        let toothbrushingType = HKObjectType.categoryType(forIdentifier: .toothbrushingEvent)!
        
        let toothbrushingSample = HKCategorySample(
            type: toothbrushingType,
            value: 0,
            start: startDate,
            end: endDate
        )
        
        healthStore.save(toothbrushingSample) { success, error in
            if let error = error {
                print("Error saving toothbrushing data: \(error.localizedDescription)")
            } else if success {
                print("Successfully saved toothbrushing data.")
            } else {
                print("Failed to save toothbrushing data.")
            }
        }
    }
}
