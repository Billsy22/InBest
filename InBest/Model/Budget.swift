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
    var amount: Double
    var ckRecordID: CKRecordID?
    var investments: [Investment] = []
    var asCKRecord: CKRecord {
        let record: CKRecord
        if let recordID = ckRecordID {
            record = CKRecord(recordType: "Budget", recordID: recordID)
        } else {
            record = CKRecord(recordType: "Budget")
        }
        record.setObject(date as CKRecordValue, forKey: "DateCreated")
        record.setObject(amount as CKRecordValue, forKey: "Amount")
        
        ckRecordID = record.recordID
        
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
