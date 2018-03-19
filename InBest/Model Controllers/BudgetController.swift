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
            print("Budgets Set")
            NotificationCenter.default.post(name: NotificationName.budgetsSet, object: nil)
        }
    }
    var sortedBudgets: [Budget] {
        return budgets.sorted(by: { $0.date > $1.date })
    }
    
    // MARK: -  CRUD
    // Save/Update Budget
    func save(budget: Budget, completion: @escaping() -> Void) {
        if !budgets.contains(budget) {
            self.budgets.append(budget)
        }
        ckManager.saveRecordsToCloudKit(records: [budget.asCKRecord], database: ckManager.publicDB, perRecordCompletion: nil) { (records, _, error) in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
        }
        print("Budget Count: \(self.budgets.count)")
        print("Budget Saved")
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
            for budget in self.budgets {
                self.fetchInvestmentsFor(budget: budget, completion: {
                    for investment in budget.investments {
                        self.fetchCompany(investment: investment, completion: {})
                    }
                })
            }
            print("Budgets Loaded")
        })
    }
    
    // Fetch Investments
    func fetchInvestmentsFor(budget: Budget, completion: @escaping() -> Void) {
        ckManager.fetchRecordOf(type: "Investment") { (records, error) in
            if let error = error {
                print("Error Fetching Investments: \(error.localizedDescription)")
                return
            }
            guard let records = records else { completion(); return }
            let investments = records.flatMap( { Investment(cloudKitRecord: $0) })
            budget.investments = investments
            completion()
        }
    }
    
    // Fetch Companies
    func fetchCompany(investment: Investment, completion: @escaping() -> Void) {
        ckManager.fetchRecordOf(type: "Company") { (records, error) in
            if let error = error {
                print("Error fetching company for investment: \(error.localizedDescription)")
                return
            }
            guard let records = records else { completion(); return }
            guard let company = Company(cloudKitRecord: records[0]) else { completion(); return }
            investment.company = company
            completion()
        }
    }
    
    // Delete Budget
    func delete(budget: Budget) {
        ckManager.delete(budget: budget) { (_, error) in
            if let error = error {
                print("Error Deleting budget: \(error.localizedDescription)")
                return
            }
            guard let index = self.budgets.index(of: budget) else { return }
            self.budgets.remove(at: index)
        }
    }
}
