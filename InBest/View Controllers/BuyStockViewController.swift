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
    @IBOutlet weak var yourSharesLabel: UILabel!
    @IBOutlet weak var moneyTextField: UITextField!
    var budget: Budget?
    var company: Company?
    var stockInfo: StockInfo?
    
    // MARK: -  Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        updateInitialViews()
    }
    
    // MARK: -  Actions
    @IBAction func calculateSharesButtonTapped(_ sender: Any) {
        guard let budget = budget,
            let stockInfo = stockInfo,
        let moneyInputText = moneyTextField.text, !moneyInputText.isEmpty else { return }
        guard let moneyInput = Double(moneyInputText) else { return }
        if budget.currentAmount >= moneyInput {
            guard let currentPrice = Double(stockInfo.close) else { return }
            let yourShares = moneyInput / currentPrice
            yourSharesLabel.text = "\(yourShares)"
        }
    }
    
    @IBAction func buyButtonTapped(_ sender: Any) {
        guard let company = company,
            let budget = budget,
            let amountAsString = moneyTextField.text, !amountAsString.isEmpty else { return }
        guard let amountOfMoney = Double(amountAsString) else { return }
        InvestmentController.shared.investIn(company: company, amountOfMoney: amountOfMoney, fromBudget: budget)
        performSegue(withIdentifier: "unwindToBudgetDetailVC", sender: self)
    }
    
    
    /*
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     }
     */
    
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
