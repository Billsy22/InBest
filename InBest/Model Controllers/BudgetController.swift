//
//  BudgetController.swift
//  InBest
//
//  Created by Taylor Bills on 3/13/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class BudgetController {
    
    // MARK: -  Properties
    static let shared = BudgetController()
    let ckManager = CloudKitManager()
    var budgets: [Budget] = [] {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("budgetsSet"), object: nil)
        }
    }
    var sortedBudgets: [Budget] {
        return budgets.sorted(by: { $0.date > $1.date })
    }
    
    // MARK: -  CRUD
    // Save/Update Budget
    func save(budget: Budget, completion: @escaping() -> Void) {
        print(budgets.count)
        if !budgets.contains(budget) {
            self.budgets.append(budget)
        }
        ckManager.saveRecordsToCloudKit(records: [budget.asCKRecord], database: ckManager.publicDB, perRecordCompletion: nil) { (records, _, error) in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            print("saved")
        }
    }
    
    // Load Budgets
    func load() {
        ckManager.fetchRecordOf(type: "Budget", completion: { (records, error) in
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
            for budget in budgetsPulled {
                self.fetchInvestmentsFor(budget: budget, completion: {
                    for investment in budget.investments {
                        self.fetchCompany(investedIn: investment, completion: {
                            print("Budgets Loaded")
                        })
                    }
                })
            }
            print("loaded")
        })
    }
    
    // Fetch Investments
    func fetchInvestmentsFor(budget: Budget, completion: @escaping() -> Void) {
        ckManager.fetchRecordOf(type: "Investment") { (records, error) in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            guard let records = records else { completion(); return }
            let investments = records.flatMap( { Investment(cloudKitRecord: $0) })
            budget.investments = investments
            completion()
        }
    }
    
    // Fetch Companies
    func fetchCompany(investedIn: Investment, completion: @escaping() -> Void) {
        ckManager.fetchRecordOf(type: "Company") { (records, error) in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            guard let records = records else { completion(); return }
            let company = Company(cloudKitRecord: records[0])
            investedIn.company = company
            completion()
        }
    }
    
    // Delete Budget
    func delete(budget: Budget) {
        ckManager.delete(budget: budget) { (_, error) in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
        }
        guard let index = self.budgets.index(of: budget) else { return }
        self.budgets.remove(at: index)
    }
}
