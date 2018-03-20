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
    
    func saveRecordsToCloudKit(records: [CKRecord], database: CKDatabase, perRecordCompletion: ((CKRecord?, Error?) -> Void)?, completion: (([CKRecord]?, [CKRecordID]?, Error?) -> Void)?) {
        
        let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
        operation.queuePriority = .high
        operation.qualityOfService = .userInteractive
        operation.savePolicy = .changedKeys
        operation.perRecordCompletionBlock = perRecordCompletion
        operation.modifyRecordsCompletionBlock = completion
        database.add(operation)
    }
    
    func fetchRecordOf(type: String, completion: @escaping(([CKRecord]?, Error?) -> Void)) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: type, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil, completionHandler: completion)
        print("\(type)s Loaded from the Cloud")
    }
    
    // MARK: - Delete
    
    func deleteRecordWithID(_ recordID: CKRecordID, completion: ((_ recordID: CKRecordID?, _ error: Error?) -> Void)?) {
        
        publicDB.delete(withRecordID: recordID) { (recordID, error) in
            completion?(recordID, error)
        }
    }
    
    func deleteRecordsWithID(_ recordIDs: [CKRecordID], completion: ((_ records: [CKRecord]?, _ recordIDs: [CKRecordID]?, _ error: Error?) -> Void)?) {
        
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: recordIDs)
        operation.savePolicy = .changedKeys
        operation.queuePriority = .high
        operation.qualityOfService = .userInteractive
        
        operation.modifyRecordsCompletionBlock = completion
        
        publicDB.add(operation)
    }
}
