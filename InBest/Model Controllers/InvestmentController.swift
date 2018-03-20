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
    var investments: [Investment] = []
    
    // MARK: -  CRUD
    
    // Save Investments
    func save(investment: Investment, completion: @escaping() -> Void) {
        
        guard let company = investment.company else { return }
        ckManager.saveRecordsToCloudKit(records: [investment.asCKRecord, company.asCKRecord], database: ckManager.publicDB, perRecordCompletion: nil) { (records, _, error) in
            if let error = error {
                print("Error Saving Investment: \(error.localizedDescription)")
                print("Error Saving Company: \(error.localizedDescription)")
                return
            }
            print("investment saved")
            completion()
        }
    }
    
//    // Make an investment
//    func investIn(company: Company, amountOfMoney: Double, fromBudget budget: Budget) {
//        StockInfoController.shared.fetchCurrentStockInfoFor(symbol: company.symbol) {
//            let stockInfo = StockInfoController.shared.stockInfo[0]
//            guard let stockPrice = Double(stockInfo.close) else { return }
//            if budget.currentAmount >= amountOfMoney {
//                let numberOfShares = amountOfMoney / stockPrice
//                let investment = Investment(company: company, initialAmountOfMoney: amountOfMoney, numberOfShares: numberOfShares, budget: budget)
//                self.investments.append(investment)
//                budget.currentAmount -= amountOfMoney
//                self.save(investment: investment, completion: {
//                    print("Bought Stock")
//                })
//            } else {
//                print("not enough money")
//                return
//            }
//        }
//    }
//    
    // Create Investment
    @discardableResult func createInvestmentWith(company: Company, initialAmountOfMoney: Double, numberOfShares: Double, budget: Budget) -> Investment {
        let investment = Investment(company: company, initialAmountOfMoney: initialAmountOfMoney, numberOfShares: numberOfShares, budget: budget)
        company.investment = investment
        budget.investments.append(investment)
        return investment
    }
    
    // Sell investment
    func sell(stockFrom company: Company, into budget: Budget, investment: Investment) {
        StockInfoController.shared.fetchCurrentStockInfoFor(symbol: company.symbol) {
            let stockInfo = StockInfoController.shared.stockInfo[0]
            guard let stockPrice = Double(stockInfo.close) else { return }
            budget.currentAmount += (investment.numberOfShares * stockPrice)
            guard let index = budget.investments.index(of: investment) else { return }
            budget.investments.remove(at: index)
            BudgetController.shared.save(budget: budget, completion: {
                print("Stock Sold")
            })
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
