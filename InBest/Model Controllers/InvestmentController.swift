//
//  MathFunctionsController.swift
//  InBest
//
//  Created by Taylor Bills on 3/15/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import Foundation

class InvestmentController {
    
    // MARK: -  Properties
    static let shared = InvestmentController()
    let ckManager = CloudKitManager()
    var investments: [Investment] = [] {
        didSet {
            print("Investments set")
            NotificationCenter.default.post(name: Notification.Name("InvestmentsSet"), object: nil)
        }
    }
    
    // MARK: -  CRUD
    
    // Save Investments
    func save(investment: Investment, completion: @escaping() -> Void) {
        ckManager.saveRecordsToCloudKit(records: [investment.asCKRecord], database: ckManager.publicDB, perRecordCompletion: nil) { (records, _, error) in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            print("investment saved")
        }
    }
    
    // Make an investment
    func investIn(company: Company, amountOfMoney: Double, fromBudget budget: Budget) {
        StockInfoController.shared.fetchCurrentStockInfoFor(symbol: company.symbol) {
            let stockInfo = StockInfoController.shared.stockInfo[0]
            guard let stockPrice = Double(stockInfo.close) else { return }
            if budget.currentAmount >= amountOfMoney {
                let numberOfShares = amountOfMoney / stockPrice
                let investment = Investment(company: company, initialAmountOfMoney: amountOfMoney, numberOfShares: numberOfShares, budget: budget)
                self.save(investment: investment, completion: {
                    self.investments.append(investment)
                    budget.currentAmount -= amountOfMoney
                })
            } else {
                print("not enough money")
                return
            }
        }
    }
    
    // Sell investment
    func sell(stockFrom company: Company, into budget: Budget, investment: Investment) {
        StockInfoController.shared.fetchCurrentStockInfoFor(symbol: company.symbol) {
            let stockInfo = StockInfoController.shared.stockInfo[0]
            guard let stockPrice = Double(stockInfo.close) else { return }
            budget.currentAmount += investment.numberOfShares * stockPrice
            guard let index = budget.investments.index(of: investment) else { return }
            budget.investments.remove(at: index)
            BudgetController.shared.save(budget: budget)
        }
    }
    
    //Change in investment
    func changeAmountFrom(budget: Budget, company: Company, and investment: Investment) {
        StockInfoController.shared.fetchCurrentStockInfoFor(symbol: company.symbol) {
            let stockInfo = StockInfoController.shared.stockInfo[0]
            guard let pricePerShare = Double(stockInfo.close) else { return }
            let numberOfShares = investment.initialAmountOfMoney / pricePerShare
            investment.currentAmount += (numberOfShares * pricePerShare)
        }
    }
}
