//
//  Investment.swift
//  InBest
//
//  Created by Taylor Bills on 3/15/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import Foundation
import CloudKit

class Investment {
    
    // MARK: -  Properties
    weak var budget: Budget?
    var company: Company?
    let initialAmountOfMoney: Double
    var currentAmount: Double
    let numberOfShares: Int
    var ckRecordID: CKRecordID?
    var asCKRecord: CKRecord {
        let record: CKRecord
        if let recordID = ckRecordID {
            record = CKRecord(recordType: "Investment", recordID: recordID)
        } else {
            record = CKRecord(recordType: "Investment")
        }
        ckRecordID = record.recordID
        record.setObject(initialAmountOfMoney as CKRecordValue, forKey: "InitialAmountOfMoney")
        record.setObject(currentAmount as CKRecordValue, forKey: "CurrentAmount")
        record.setObject(numberOfShares as CKRecordValue, forKey: "NumberOfShares")
        if let budget = budget,
            let budgetRecordID = budget.ckRecordID {
            let budgetReference = CKReference(recordID: budgetRecordID, action: .deleteSelf)
            record.setObject(budgetReference, forKey: "BudgetReference")
        }
        return record
    }
    
    // MARK: -  Initializer
    init?(cloudKitRecord: CKRecord) {
        guard let initialAMountOfMoney = cloudKitRecord["InitialAmountOfMoney"] as? Double,
            let currentAmountOfMoney = cloudKitRecord["CurrentAmount"] as? Double,
            let numberOfShares = cloudKitRecord["NumberOfShares"] as? Int else { return nil }
        
        self.initialAmountOfMoney = initialAMountOfMoney
        self.currentAmount = currentAmountOfMoney
        self.numberOfShares = numberOfShares
        self.ckRecordID = cloudKitRecord.recordID
    }
    
    init(company: Company?, initialAmountOfMoney: Double, numberOfShares: Int, budget: Budget) {
        self.budget = budget
        self.company = company
        self.initialAmountOfMoney = initialAmountOfMoney
        self.currentAmount = initialAmountOfMoney
        self.numberOfShares = numberOfShares
    }
}

extension Investment: Equatable {
    static func ==(lhs: Investment, rhs: Investment) -> Bool {
        return lhs.company == rhs.company &&
        lhs.initialAmountOfMoney == rhs.initialAmountOfMoney &&
        lhs.numberOfShares == rhs.numberOfShares &&
        lhs.budget == rhs.budget &&
        lhs.ckRecordID == rhs.ckRecordID
    }
}
