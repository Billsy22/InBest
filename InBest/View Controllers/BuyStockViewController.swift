//
//  BuyStockViewController.swift
//  InBest
//
//  Created by Taylor Bills on 3/16/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import UIKit

class BuyStockViewController: UIViewController {
    
    // MARK: -  Properties
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companySymbolLabel: UILabel!
    @IBOutlet weak var pricePerShareLabel: UILabel!
    @IBOutlet weak var yourCostsLabel: UILabel!
    @IBOutlet weak var sharesTextField: UITextField!
    var budget: Budget?
    var company: Company?
    var stockInfo: StockInfo?
    
    // MARK: -  Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        updateInitialViews()
    }
    
    // MARK: -  Actions
    @IBAction func calculateCostButtonTapped(_ sender: Any) {
        guard let budget = budget,
            let stockInfo = stockInfo,
        let moneyInputText = sharesTextField.text, !moneyInputText.isEmpty else { return }
        guard let moneyInput = Double(moneyInputText) else { return }
        if budget.currentAmount >= moneyInput {
            guard let currentPrice = Double(stockInfo.close) else { return }
            let yourShares = moneyInput / currentPrice
            yourCostsLabel.text = "\(yourShares)"
            sharesTextField.resignFirstResponder()
        }
    }
    
    @IBAction func buyButtonTapped(_ sender: Any) {
        guard let company = company,
            let budget = budget,
            let stockInfo = stockInfo,
            let amountAsString = sharesTextField.text, !amountAsString.isEmpty else { return }
        guard let amountOfMoney = Double(amountAsString) else { return }
        guard let currentPrice = Double(stockInfo.close) else { return }
        let numberOfShares = amountOfMoney / currentPrice
        InvestmentController.shared.createInvestmentWith(company: company, initialAmountOfMoney: amountOfMoney, numberOfShares: numberOfShares, budget: budget)
        BudgetController.shared.save(budget: budget) {
            budget.currentAmount -= amountOfMoney
        }
    }
    
    // MARK: -  UpdateViews
    func updateInitialViews() {
        guard let budget = budget,
            let company = company,
            let stockInfo = stockInfo else { return }
        companyNameLabel.text = company.name
        companySymbolLabel.text = company.symbol
        pricePerShareLabel.text = stockInfo.close
        navigationItem.title = "\(budget.currentAmount)"
    }
}
