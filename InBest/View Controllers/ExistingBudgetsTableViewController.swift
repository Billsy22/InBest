//
//  ExistingBudgetsTableViewController.swift
//  InBest
//
//  Created by Taylor Bills on 3/13/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import UIKit

class ExistingBudgetsTableViewController: UITableViewController {
    
    // MARK: -  Properties

    override func viewDidLoad() {
        super.viewDidLoad()
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
        let budget = BudgetController.shared.budgets[indexPath.row]
        cell.textLabel?.text = "\(budget.date)"
        cell.detailTextLabel?.text = "\(budget.amount)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectedBudgetDetail" {
            guard let detailVC = segue.destination as? BudgetDetailTableViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let budget = BudgetController.shared.budgets[indexPath.row]
            detailVC.budget = budget
        }
    }
}