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
        NotificationCenter.default.addObserver(self, selector: #selector(redrawNavigationItem), name: NotificationName.budgetAmountChanged, object: nil)
    }
    
    // MARK: -  Actions
    @IBAction func calculateCostButtonTapped(_ sender: Any) {
        guard let stockInfo = stockInfo,
            let sharesInputText = sharesTextField.text, !sharesInputText.isEmpty else { return }
        guard let sharesInput = Double(sharesInputText) else { return }
        guard let currentPrice = Double(stockInfo.close) else { return }
        let yourCost = sharesInput * currentPrice
        yourCostsLabel.text = "$\(yourCost.roundedToMoney())"
        sharesTextField.resignFirstResponder()
    }
    
    @IBAction func buyButtonTapped(_ sender: Any) {
        guard let company = company,
            let budget = budget,
            let stockInfo = stockInfo,
            let amountOfSharesAsString = sharesTextField.text, !amountOfSharesAsString.isEmpty else { return }
        guard let amountOfShares = Int(amountOfSharesAsString) else { return }
        guard let currentPrice = Double(stockInfo.close) else { return }
        let cost = Double(amountOfShares) * currentPrice
        if cost > budget.currentAmount {
            let alert = UIAlertController(title: "Whoops!", message: "You Don't have enough money, try again", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                self.sharesTextField.text = ""
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        } else {
            InvestmentController.shared.createInvestmentWith(company: company, initialAmountOfMoney: cost, numberOfShares: amountOfShares, budget: budget)
            BudgetController.shared.save(budget: budget) {
                budget.currentAmount -= cost
            }
            self.performSegue(withIdentifier: "unwindToBudgetDetailVCWithSegue", sender: self)
        }
    }
    
    // MARK: -  UpdateViews
    func updateInitialViews() {
        guard let budget = budget,
            let company = company,
            let stockInfo = stockInfo else { return }
        guard let sharePrice = Double(stockInfo.close) else { return }
        companyNameLabel.text = company.name
        companySymbolLabel.text = company.symbol
        pricePerShareLabel.text = "$\(sharePrice.roundedToMoney())"
        navigationItem.title = "$\(budget.currentAmount)"
    }
    
    @objc func redrawNavigationItem() {
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
        }
    }
}
