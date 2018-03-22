//
//  CustomUser.swift
//  InBest
//
//  Created by Taylor Bills on 3/22/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import Foundation
import CloudKit

class CustomUser {
    
    // MARK: -  Properties
    var screenName: String
    var ckRecordID: CKRecordID?
    let appleUserReference: CKReference

    // MARK: -  Initializers
    init(screenName: String, appleUserReference: CKReference) {
        self.screenName = screenName
        self.appleUserReference = appleUserReference
    }
    
    init?(cloudKitRecord: CKRecord) {
        guard let screenName = cloudKitRecord["ScreenName"] as? String,
            let appleUserReference = cloudKitRecord["AppleUserReference"] as? CKReference else { return nil }
        self.screenName = screenName
        self.appleUserReference = appleUserReference
        self.ckRecordID = cloudKitRecord.recordID
    }
}

extension CKRecord {
    
    // MARK: -  Convenience Initializer
    convenience init(customUser: CustomUser) {
        if let recordID = customUser.ckRecordID {
            self.init(recordType: "CustomUser", recordID: recordID)
        } else {
            self.init(recordType: "CustomUser")
        }
        self.setObject(customUser.screenName as CKRecordValue, forKey: "ScreenName")
        self.setObject(customUser.appleUserReference, forKey: "AppleUserReference")
    }
}
