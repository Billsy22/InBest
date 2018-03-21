//
//  InvestmentDetailViewController.swift
//  InBest
//
//  Created by Taylor Bills on 3/19/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import UIKit

class InvestmentDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: -  Properties
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companySymbolLabel: UILabel!
    @IBOutlet weak var pricePerShareLabel: UILabel!
    @IBOutlet weak var investedAmountLabel: UILabel!
    @IBOutlet weak var sellAmountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var budget: Budget?
    var investment: Investment?
    var currentPrice: StockInfo?
    var lastWeekHighs: [StockInfo?] = []
    @IBOutlet weak var sharesLabel: UILabel!
    
    // MARK: -  Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        updateViews()
    }
    
    // MARK: -  Table View Data Source Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let lastSeven = lastWeekHighs.prefix(7)
        return lastSeven.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath)
        guard let stockInfo = lastWeekHighs[indexPath.row] else { return UITableViewCell() }
        cell.textLabel?.text = stockInfo.dateString
        cell.detailTextLabel?.text = stockInfo.high
        return cell
    }
    
    // MARK: -  Action
    @IBAction func sellButtonTapped(_ sender: Any) {
        guard let investment = investment, let budget = budget else { return }
        guard let company = investment.company else { return }
        InvestmentController.shared.sell(stockFrom: company, into: budget, investment: investment)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: -  Update Views
    func updateViews() {
        guard let budget = budget else { return }
        navigationController?.title = "\(budget.currentAmount)"
        guard let investment = investment else { return }
        guard let company = investment.company else { return }
        companyNameLabel.text = company.name
        companySymbolLabel.text = company.symbol
        investedAmountLabel.text = "\(investment.initialAmountOfMoney)"
        sharesLabel.text = "\(investment.numberOfShares)"
        StockInfoController.shared.fetchCurrentStockInfoFor(symbol: company.symbol) {
            DispatchQueue.main.async {
            self.currentPrice = StockInfoController.shared.stockInfo[0]
            guard let currentPrice = self.currentPrice else { return }
                guard let currentPriceAsDouble = Double(currentPrice.close) else { return }
                self.pricePerShareLabel.text = "\(currentPrice.close)"
                let sellAmount = investment.numberOfShares * currentPriceAsDouble
                self.sellAmountLabel.text = "\(sellAmount)"
            }
            self.updateTableViewInfo()
        }
    }
    
    func updateTableViewInfo() {
        guard let investment = investment else { return }
        guard let company = investment.company else { return }
        StockInfoController.shared.fetchLastWeeksStockInfoFor(symbol: company.symbol) {
            DispatchQueue.main.async {
                self.lastWeekHighs = StockInfoController.shared.stockInfo
                self.tableView.reloadData()
            }
        }
    }
}
