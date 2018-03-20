//
//  StockInfoViewController.swift
//  InBest
//
//  Created by Taylor Bills on 3/15/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import UIKit

class StockInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: -  Properties
    @IBOutlet weak var stockInfoTableView: UITableView!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companySymbolLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    var budget: Budget?
    var company: Company?
    var stockInfo: StockInfo?
    var weeklyStocks: [StockInfo?] = []
    
    // MARK: -  Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        stockInfoTableView.delegate = self
        stockInfoTableView.dataSource = self
        updateViews()
    }
    
    // MARK: -  Table View Data Source Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let weeklyStocksTop7 = weeklyStocks.prefix(7)
        return weeklyStocksTop7.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockInfoCell", for: indexPath)
        guard let stockInfo = weeklyStocks[indexPath.row] else { return UITableViewCell() }
        cell.textLabel?.text = stockInfo.dateString
        cell.detailTextLabel?.text = stockInfo.high
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BuyStock" {
            guard let buyStock = segue.destination as? BuyStockViewController else { return }
            guard let company = company,
                let budget = budget,
                let stockInfo = stockInfo else { return }
            buyStock.budget = budget
            buyStock.company = company
            buyStock.stockInfo = stockInfo
        }
    }
    
    // MARK: -  UpdateViews
    func updateViews() {
        guard let company = company, let budget = budget else { return }
        navigationItem.title = "\(budget.currentAmount)"
        companyNameLabel.text = company.name
        companySymbolLabel.text = company.symbol
        StockInfoController.shared.fetchCurrentStockInfoFor(symbol: company.symbol) {
            DispatchQueue.main.async {
                self.stockInfo = StockInfoController.shared.sortedStockInfo.first
                guard let stockInfo = self.stockInfo else { return }
                self.currentPriceLabel.text = stockInfo.close
            }
            self.updateTableView()
        }
    }
    
    func updateTableView() {
        guard let company = company else { return }
        StockInfoController.shared.fetchLastWeeksStockInfoFor(symbol: company.symbol) {
            DispatchQueue.main.async {
                self.weeklyStocks = StockInfoController.shared.sortedStockInfo
                self.stockInfoTableView.reloadData()
            }
        }
    }
}

extension StockInfoViewController {
    
}
