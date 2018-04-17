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
    @IBOutlet weak var activitiyIndicator: UIActivityIndicatorView!
    @IBOutlet weak var sellButton: UIButton!
    var budget: Budget?
    var investment: Investment?
    var currentPrice: StockInfo?
    var lastWeekHighs: [StockInfo?] = []
    @IBOutlet weak var sharesLabel: UILabel!
    
    // MARK: -  Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        activitiyIndicator.color = UIColor(red: 0.666, green: 0.878, blue: 0.695, alpha: 1)
        sellButton.isEnabled = false
        sellButton.setTitle("", for: .disabled)
        activitiyIndicator.startAnimating()
        tableView.delegate = self
        tableView.dataSource = self
        updateTableViewInfo()
    }
    
    // MARK: -  Table View Data Source Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let lastSeven = lastWeekHighs.prefix(7)
        return lastSeven.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath)
        guard let stockInfo = lastWeekHighs[indexPath.row] else { return UITableViewCell() }
        cell.textLabel?.text = DateFormat.shared.convert(date: stockInfo.date)
        guard let highPrice = Double(stockInfo.high),
            let lowPrice = Double(stockInfo.low) else { return UITableViewCell() }
        cell.detailTextLabel?.text = "High: \(highPrice.roundedToMoney())\nLow: \(lowPrice.roundedToMoney())"
        return cell
    }
    
    // MARK: -  Action
    @IBAction func sellButtonTapped(_ sender: Any) {
        guard let investment = investment, let budget = budget,
        let currentPrice = currentPrice else { return }
        guard let company = investment.company else { return }
        guard let sellPrice = Double(currentPrice.close) else { return }
        InvestmentController.shared.sell(stockFrom: company, into: budget, investment: investment, atPrice: sellPrice)
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
        investedAmountLabel.text = "$\(investment.initialAmountOfMoney)"
        sharesLabel.text = "\(investment.numberOfShares)"
        StockInfoController.shared.fetchCurrentStockInfoFor(symbol: company.symbol) {
            DispatchQueue.main.async {
            self.currentPrice = StockInfoController.shared.sortedStockInfo.first
            guard let currentPrice = self.currentPrice else { return }
                guard let currentPriceAsDouble = Double(currentPrice.close) else { return }
                self.pricePerShareLabel.text = "$\(currentPriceAsDouble.roundedToMoney())"
                let sellAmount = Double(investment.numberOfShares) * currentPriceAsDouble
                self.sellAmountLabel.text = "$\(sellAmount.roundedToMoney())"
                print(currentPrice.dateString)
                self.activitiyIndicator.stopAnimating()
                self.activitiyIndicator.isHidden = true
                self.sellButton.isEnabled = true
                self.sellButton.setTitle("Sell", for: .normal)
            }
        }
    }
    
    func updateTableViewInfo() {
        guard let investment = investment else { return }
        guard let company = investment.company else { return }
        StockInfoController.shared.fetchLastWeeksStockInfoFor(symbol: company.symbol) {
            DispatchQueue.main.async {
                self.lastWeekHighs = StockInfoController.shared.sortedStockInfo
                self.tableView.reloadData()
            }
        }
        updateViews()
    }
}
