//
//  BudgetController.swift
//  InBest
//
//  Created by Taylor Bills on 3/13/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import Foundation
import CloudKit

class BudgetController {
    
    // MARK: -  Properties
    static let shared = BudgetController()
    let ckManager = CloudKitManager()
    var budgets: [Budget] = []
    
    // MARK: -  CRUD
    
    func save(budget: Budget) {
        ckManager.saveRecordsToCloudKit(records: [budget.asCKRecord], database: ckManager.publicDB, perRecordCompletion: nil) { (records, _, error) in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
        }
    }
    
    func load() {
        ckManager.fetchBudget { (records, error) in
            if let error = error {
                print("Error loading form the cloud: \(error.localizedDescription)")
                return
            }
            guard let records = records else { print("No records found"); return }
            var budgetsPulled: [Budget] = []
            for record in records {
                guard let newBudget = Budget(record: record) else { continue }
                budgetsPulled.append(newBudget)
            }
            self.budgets = budgetsPulled
            print(self.budgets.count)
        }
    }
}
