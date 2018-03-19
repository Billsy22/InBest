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
    
    // MARK: -  Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        stockInfoTableView.delegate = self
        stockInfoTableView.dataSource = self
        updateViews()
    }
    
    // MARK: -  Table View Data Source Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StockInfoController.shared.stockInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockInfoCell", for: indexPath)
        let stockInfo = StockInfoController.shared.stockInfo[indexPath.row]
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
                self.stockInfo = StockInfoController.shared.stockInfo[0]
                guard let stockInfo = self.stockInfo else { return }
                self.currentPriceLabel.text = stockInfo.close
                self.stockInfoTableView.reloadData()
            }
        }
    }
    
    func updateTableView() {
        guard let company = company else { return }
    }
}
