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
    var budgets: [Budget] = []
    {
        didSet {
            print("Budgets Set")
            NotificationCenter.default.post(name: NotificationName.budgetsSet, object: nil)
        }
    }

    var sortedBudgets: [Budget] {
        return budgets.sorted(by: { $0.date > $1.date })
    }
    
    func sortedBudgets(budgets: [Budget]) -> [Budget] {
        let sortedBudget = budgets.sorted(by: { $0.date > $1.date })
        return sortedBudget
    }
    
    // MARK: -  CRUD
    // Save/Update Budget
    func createBudgetOn(date: Date, initialAmount: Double) {
        guard let currentUser = CustomUserController.shared.currentUser else { return }
        let budget = Budget(customUser: currentUser, date: date, initialAmount: initialAmount)
        budgets.append(budget)
        save(budget: budget) {
            print("BudgetCreated")
        }
    }
    
    func save(budget: Budget, completion: @escaping() -> Void) {
        if !budgets.contains(budget) {
            self.budgets.append(budget)
        }
        ckManager.saveRecordsToCloudKit(records: [budget.asCKRecord], database: ckManager.publicDB, perRecordCompletion: nil) { (records, _, error) in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            for investment in budget.investments {
                guard let company = investment.company else { return }
                self.ckManager.saveRecordsToCloudKit(records: [investment.asCKRecord, company.asCKRecord], database: self.ckManager.publicDB, perRecordCompletion: nil, completion: { (records, _, error) in
                    if let error = error {
                        print("Error saving: \(#function) \(error.localizedDescription)")
                    }
                })
            }
        }
        print("Budget Count: \(self.budgets.count)")
        print("Budget Saved")
    }
    
    // Load Budgets
    // TODO: - Modify Predicate
    func load(currentUser: CustomUser, completion: @escaping () -> Void = { }) {
        guard let currentUserRecordID = currentUser.ckRecordID else {completion(); return }
        let predicate = NSPredicate(format: "CustomUserReference == %@", currentUserRecordID)
        ckManager.fetchRecordOf(type: "Budget", predicate: predicate, completion: { (records, error) in
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
            let dispatchGroup = DispatchGroup()
            for budget in self.budgets {
                dispatchGroup.enter()
                self.fetchInvestmentsFor(budget: budget, completion: {
                    let subgroup = DispatchGroup()
                
                    for investment in budget.investments {
                        subgroup.enter()
                        self.fetchCompany(investment: investment, completion: {
                            subgroup.leave()
                        })
                    }
                    
                    subgroup.notify(queue: DispatchQueue.main, execute: {
                        dispatchGroup.leave()
                    })
                    
                })
            }
            
            dispatchGroup.notify(queue: DispatchQueue.main, execute: {
                completion()
                print("Budgets Loaded")
            })
        })
    }
    
    // Fetch Investments
    func fetchInvestmentsFor(budget: Budget, completion: @escaping() -> Void) {
        guard let budgetRecordID = budget.ckRecordID else { completion(); return }
        let predicate = NSPredicate(format: "BudgetReference == %@", budgetRecordID)
        ckManager.fetchRecordOf(type: "Investment", predicate: predicate) { (records, error) in
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
        guard let investmentRecordID = investment.ckRecordID else { completion(); return }
        let predicate = NSPredicate(format: "InvestmentReference == %@", investmentRecordID)
        ckManager.fetchRecordOf(type: "Company", predicate: predicate) { (records, error) in
            if let error = error {
                print("Error fetching company for investment: \(error.localizedDescription)")
                return
            }
            guard let records = records else { completion(); return }
            let companies = records.flatMap( {Company(cloudKitRecord: $0)} )
            investment.company = companies.first
            completion()
        }
    }
    
    // Delete Budget
    func delete(budget: Budget) {
        guard let index = self.budgets.index(of: budget) else { return }
        self.budgets.remove(at: index)
        guard let budgetID = budget.ckRecordID else { return }
        ckManager.deleteRecordsWithID([budgetID]) { (records, _, error) in
            if let error = error {
                print("Error deleting budget: \(#function) \(error.localizedDescription)")
            }
        }
    }
}
