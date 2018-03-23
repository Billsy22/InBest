//
//  BudgetDetailTableViewController.swift
//  InBest
//
//  Created by Taylor Bills on 3/13/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import UIKit

class BudgetDetailTableViewController: UITableViewController {
    
    // MARK: -  Properties
    var budget: Budget?
    
    // MARK: -  Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        NotificationCenter.default.addObserver(self, selector: #selector(loadInvestments), name: NotificationName.investmentsSet, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadNavigationItem), name: NotificationName.budgetAmountChanged, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let budget = budget else { return 0 }
        return budget.investments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "investmentCell", for: indexPath)
        guard let budget = budget else { return UITableViewCell() }
        let investment = budget.investments[indexPath.row]
        guard let company = investment.company else { return UITableViewCell() }
        cell.textLabel?.text = company.name
        cell.detailTextLabel?.text = "Initial Investment:\n$\(investment.initialAmountOfMoney.roundedToMoney())"
        return cell
    }
    
    // MARK: -  Update Views
    func updateViews() {
        guard let budget = budget else { return }
        navigationItem.title = "$\(budget.currentAmount.roundedToMoney())"
    } 
    
    @objc func loadInvestments() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func reloadNavigationItem() {
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: -  Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let budget = budget else { return }
        BudgetController.shared.save(budget: budget) {
        }
        self.performSegue(withIdentifier: "toBudgetList", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchTableViewController" {
            guard let searchVC = segue.destination as? SearchTableViewController else { return }
            guard let budget = budget else { return }
            searchVC.budget = budget
        } else if segue.identifier == "investmentDetail" {
            guard let investmentDetailVC = segue.destination as? InvestmentDetailViewController else { return }
            guard let budget = budget else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let investment = budget.investments[indexPath.row]
            investmentDetailVC.budget = budget
            investmentDetailVC.investment = investment
        }
    }
    
    @IBAction func unwindToBudgetDetailVC(segue: UIStoryboardSegue) {}
}
