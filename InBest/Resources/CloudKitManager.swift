//
//  CloudKitManager.swift
//  InBest
//
//  Created by Taylor Bills on 3/13/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitManager {
    
    // MARK: -  Properties
    let publicDB = CKContainer.default().publicCloudDatabase
    
    // MARK: -  Save/Load
    
    func save(budget: Budget, completion: @escaping((CKRecord?, Error?) -> Void)) {
        publicDB.save(budget.asCKRecord, completionHandler: completion)
        print("Saved")
    }
    
    func fetchBudget(completion: @escaping(([CKRecord]?, Error?) -> Void)) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Budget", predicate: predicate)
        publicDB.perform(query, inZoneWith: nil, completionHandler: completion)
        print("Loaded")
    }
}
