//
//  ExistingBudgetsTableViewController.swift
//  InBest
//
//  Created by Taylor Bills on 3/13/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import UIKit

class ExistingBudgetsTableViewController: UITableViewController {
    
    // MARK: -  Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadBudgets), name: NotificationName.budgetsSet, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BudgetController.shared.budgets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "budgetCell", for: indexPath)
        let budget = BudgetController.shared.sortedBudgets[indexPath.row]
        cell.textLabel?.text = "Start Date:\n\(budget.dateAsString)"
        cell.detailTextLabel?.text = "Start Amount:\n\(budget.initialAmount)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let budget = BudgetController.shared.sortedBudgets[indexPath.row]
            BudgetController.shared.delete(budget: budget)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    
    // MARK: -  Load Budgets
    @objc func loadBudgets() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectedBudgetDetail" {
            guard let detailVC = segue.destination as? BudgetDetailTableViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let budget = BudgetController.shared.sortedBudgets[indexPath.row]
            detailVC.budget = budget
        }
    }
    
    @IBAction func unwindToExistingBudgetsVC(segue:UIStoryboardSegue) { }
}
