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
    var sortedBudgets: [Budget] {
        return budgets.sorted(by: { $0.date < $1.date })
    }
    var investments: [Investment] = []
    
    // MARK: -  B
    // Save/Update Budget
    func save(budget: Budget) {
        budgets.append(budget)
        print(budgets.count)
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
            print("loaded")
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
    
    // Make an investment
    func investIn(company: Company, amountOfMoney: Double, fromBudget budget: Budget) {
        StockInfoController.shared.fetchCurrentStockInfoFor(symbol: company.symbol) {
            let stockInfo = StockInfoController.shared.stockInfo[0]
            guard let stockPrice = Double(stockInfo.close) else { return }
            if budget.currentAmount >= amountOfMoney {
            let numberOfShares = amountOfMoney * stockPrice
            let investment = Investment(company: company, amountOfMoney: amountOfMoney, numberOfShares: numberOfShares)
            self.investments.append(investment)
            budget.currentAmount -= amountOfMoney
            } else {
                print("not enough money")
                return
            }
        }
    }
    
    // Sell investment
    func sell(stockFrom company: Company, into budget: Budget, andRemoveIndex: Investment) {
        StockInfoController.shared.fetchCurrentStockInfoFor(symbol: company.symbol) {
            let stockInfo = StockInfoController.shared.stockInfo[0]
            guard let stockPrice = Double(stockInfo.close) else { return }
            budget.currentAmount += stockPrice
            guard let index = self.investments.index(of: andRemoveIndex) else { return }
            self.investments.remove(at: index)
        }
    }
}
