//
//  CustomUserController.swift
//  InBest
//
//  Created by Taylor Bills on 3/22/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import Foundation
import CloudKit

class CustomUserController {
    
    // MARK: -  Properties
    static let shared = CustomUserController()
    let ckManager = CloudKitManager()
    
    var currentUser: CustomUser?
    
    // MARK: -  CRUD
    // CreateUser
    func createUserWith(screenName: String, completion: @escaping() -> Void) {
        CKContainer.default().fetchUserRecordID { (appleUsersRecordID, error) in
            if let error = error {
                print("error fetching apple user CKRecordID: \(#function) \(error.localizedDescription)")
            }
            guard let recordId = appleUsersRecordID else { return }
            let appleUserReference = CKReference(recordID: recordId, action: .deleteSelf)
            let customUser = CustomUser(screenName: screenName, appleUserReference: appleUserReference)
            let customUserRecord = CKRecord(customUser: customUser)
            self.ckManager.saveRecordsToCloudKit(records: [customUserRecord], database: self.ckManager.publicDB, perRecordCompletion: nil, completion: { (records, _, error) in
                if let error = error {
                    print("Error saving records: \(#function) \(error.localizedDescription)")
                    return
                }
                completion()
            })
            completion()
        }
    }
    
    // Fetch User
    func fetchCurrentUser(completion: @escaping() -> Void) {
        CKContainer.default().fetchUserRecordID { (appleUserRecordID, error) in
            if let error = error {
                print("Error fetchin apple user info: \(#function) \(error.localizedDescription)")
            }
            guard let recordID = appleUserRecordID else { completion(); return }
            let appleUserReference = CKReference(recordID: recordID, action: .deleteSelf)
            let predicate = NSPredicate(format: "AppleUserReference == %@", appleUserReference)
            self.ckManager.fetchRecordOf(type: "CustomUser", predicate: predicate, completion: { (records, error) in
                if let error = error {
                    print("Error fetching custom users: \(#function) \(error.localizedDescription)")
                    return
                }
                guard let record = records?.first else { return }
                let currentUser = CustomUser(cloudKitRecord: record)
                self.currentUser = currentUser
                
                completion()
            })
        }
    }
}
