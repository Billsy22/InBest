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
        cell.textLabel?.text = stockInfo.date
        cell.detailTextLabel?.text = stockInfo.high
        return cell
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: -  UpdateViews
    func updateViews() {
        guard let company = company, let budget = budget else { return }
        navigationItem.title = "\(budget.initialAmount)"
        companyNameLabel.text = company.name
        companySymbolLabel.text = company.symbol
        StockInfoController.shared.fetchLastWeeksStockInfoFor(symbol: company.symbol) {
            DispatchQueue.main.async {
                self.currentPriceLabel.text = StockInfoController.shared.stockInfo[0].close
                self.stockInfoTableView.reloadData()
            }
        }
    }
}
