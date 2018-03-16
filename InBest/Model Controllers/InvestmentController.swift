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
    
    // MARK: -  CRUD
    // Make an investment
    func investIn(company: Company, amountOfMoney: Double, fromBudget budget: Budget) {
        StockInfoController.shared.fetchCurrentStockInfoFor(symbol: company.symbol) {
            let stockInfo = StockInfoController.shared.stockInfo[0]
            guard let stockPrice = Double(stockInfo.close) else { return }
            if budget.currentAmount >= amountOfMoney {
                let numberOfShares = amountOfMoney * stockPrice
                let investment = Investment(company: company, initialAmountOfMoney: amountOfMoney, numberOfShares: numberOfShares)
                BudgetController.shared.investments.append(investment)
                budget.currentAmount -= amountOfMoney
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
            guard let index = BudgetController.shared.investments.index(of: investment) else { return }
            BudgetController.shared.investments.remove(at: index)
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
