//
//  Budget.swift
//  InBest
//
//  Created by Taylor Bills on 3/13/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import Foundation
import CloudKit

class Budget {
    
    // MARK: -  Properties
    weak var customUser: CustomUser?
    var date: Date
    var dateAsString: String {
        return DateFormat.shared.convert(date: date)
    }
    let initialAmount: Double
    var currentAmount: Double {
        didSet {
            NotificationCenter.default.post(name: NotificationName.budgetAmountChanged, object: nil)
        }
    }
    var ckRecordID: CKRecordID?
    var investments: [Investment] = [] {
        didSet {
            print("Investments set")
            NotificationCenter.default.post(name: NotificationName.investmentsSet, object: nil)
        }
    }
    var asCKRecord: CKRecord {
        let record: CKRecord
        if let recordID = ckRecordID {
            record = CKRecord(recordType: "Budget", recordID: recordID)
        } else {
            record = CKRecord(recordType: "Budget")
        }
        record.setObject(date as CKRecordValue, forKey: "DateCreated")
        record.setObject(initialAmount as CKRecordValue, forKey: "InitialAmount")
        record.setObject(currentAmount as CKRecordValue, forKey: "CurrentAmount")
        if let customUser = customUser,
            let customUserRecordID = customUser.ckRecordID {
            let customUserReference = CKReference(recordID: customUserRecordID, action: .deleteSelf)
            record.setObject(customUserReference, forKey: "CustomUserReference")
        }
        ckRecordID = record.recordID
        return record
    }
    
    // MARK: -  Initializers
    init(customUser: CustomUser, date: Date, initialAmount: Double) {
        self.customUser = customUser
        self.date = date
        self.initialAmount = initialAmount
        self.currentAmount = initialAmount
    }
    
    init?(record: CKRecord) {
        guard let date = record.object(forKey: "DateCreated") as? Date,
            let initialAmount = record.object(forKey: "InitialAmount") as? Double,
            let currentAmount = record.object(forKey: "CurrentAmount") as? Double else { return nil }
        
        self.date = date
        self.initialAmount = initialAmount
        self.currentAmount = currentAmount
        self.investments = []
        self.ckRecordID = record.recordID
    }
}

extension Budget: Equatable {
    static func ==(lhs: Budget, rhs: Budget) -> Bool {
        return lhs.date == rhs.date &&
            lhs.initialAmount == rhs.initialAmount
    }
}
