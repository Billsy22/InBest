//
//  Company.swift
//  InBest
//
//  Created by Taylor Bills on 3/12/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import Foundation
import CloudKit

class Company {
    
    // MARK: -  Properties
    weak var investment: Investment?
    let name: String
    let symbol: String
    var ckRecordID: CKRecordID?
    
    var asCKRecord: CKRecord {
        let record: CKRecord
        if let recordID = ckRecordID {
            record = CKRecord(recordType: "Company", recordID: recordID)
        } else {
            record = CKRecord(recordType: "Company")
        }
        ckRecordID = record.recordID
        record.setObject(name as CKRecordValue, forKey: "Name")
        record.setObject(symbol as CKRecordValue, forKey: "Symbol")
        if let investment = investment,
            let investmentRecordID = investment.ckRecordID {
            let investmentReference = CKReference(recordID: investmentRecordID, action: .deleteSelf)
            record.setObject(investmentReference, forKey: "InvestmentReference")
        }
        return record
    }
    
    // MARK: -  Initializer
    init?(cloudKitRecord: CKRecord) {
        guard let name = cloudKitRecord["Name"] as? String,
            let symbol = cloudKitRecord["Symbol"] as? String else { return nil }
        
        self.name = name
        self.symbol = symbol
        self.ckRecordID = cloudKitRecord.recordID
    }

    
    init?(symbol: String, dictionary: [String: Any]) {
        guard let name = dictionary["Name"] as? String else { return nil }
        self.symbol = symbol
        self.name = name
    }
    
}

extension Company: Equatable {
    static func ==(lhs: Company, rhs: Company) -> Bool {
        return lhs.name == rhs.name &&
        lhs.symbol == rhs.symbol &&
        lhs.ckRecordID == rhs.ckRecordID
    }
}
