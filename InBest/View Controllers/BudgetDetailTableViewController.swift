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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        cell.textLabel?.text = investment.company.name
        cell.detailTextLabel?.text = "\(investment.currentAmount)"
        return cell
    }
    
    // MARK: -  Update Views
    func updateViews() {
        guard let budget = budget else { return }
        navigationItem.title = "\(budget.currentAmount)"
    }
    
    // MARK: -  Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let budget = budget else { return }
        BudgetController.shared.save(budget: budget)
        performSegue(withIdentifier: "toBudgetList", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchTableViewController" {
            guard let searchVC = segue.destination as? SearchTableViewController else { return }
            guard let budget = budget else { return }
            searchVC.budget = budget
        }
    }
    
    @IBAction func unwindToBudgetDetailVC(segue: UIStoryboardSegue) {}
}
