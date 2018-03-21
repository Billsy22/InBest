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
    // Create Investment
    @discardableResult func createInvestmentWith(company: Company, initialAmountOfMoney: Double, numberOfShares: Int, budget: Budget) -> Investment {
        let investment = Investment(company: company, initialAmountOfMoney: initialAmountOfMoney, numberOfShares: numberOfShares, budget: budget)
        company.investment = investment
        budget.investments.append(investment)
        budget.currentAmount -= initialAmountOfMoney
        return investment
    }
    
    // Sell investment
    func sell(stockFrom company: Company, into budget: Budget, investment: Investment, atPrice: Double) {
            budget.currentAmount += (Double(investment.numberOfShares) * atPrice)
            guard let index = budget.investments.index(of: investment) else { return }
            budget.investments.remove(at: index)
            self.delete(investment: investment)
            BudgetController.shared.save(budget: budget, completion: {
                print("Stock Sold")
        })
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
    
    func delete(investment: Investment) {
        ckManager.deleteRecordsWithID([investment.ckRecordID!]) { (records, _, error) in
            if let error = error {
                print("error deleting investment from the cloud: \(error.localizedDescription)")
                return
            }
        }
    }
}
