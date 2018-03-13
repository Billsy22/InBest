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
    let date: Date
    let amount: Double
    let ckRecordID: CKRecordID?
    var asCKRecord: CKRecord {
        let record: CKRecord
        if ckRecordID == nil {
            record = CKRecord(recordType: "Budget")
        } else {
            record = CKRecord(recordType: "Budget", recordID: ckRecordID!)
        }
        record.setObject(date as CKRecordValue, forKey: "DateCreated")
        record.setObject(amount as CKRecordValue, forKey: "Amount")
        return record
    }
    
    // MARK: -  Initializers
    init(date: Date, amount: Double) {
        self.date = date
        self.amount = amount
        self.ckRecordID = nil
    }
    
    init?(record: CKRecord) {
        guard let date = record.object(forKey: "DateCreated") as? Date,
            let amount = record.object(forKey: "Amount") as? Double else { return nil }
        self.date = date
        self.amount = amount
        self.ckRecordID = record.recordID
    }
}

extension Budget: Equatable {
    static func ==(lhs: Budget, rhs: Budget) -> Bool {
        return lhs.date == rhs.date &&
        lhs.amount == rhs.amount
    }
}
