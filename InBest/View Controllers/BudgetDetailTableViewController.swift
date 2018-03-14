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

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BudgetController.shared.budgets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "investmentCell", for: indexPath)
        return cell
    }
    
    // MARK: -  Update Views
    func updateViews() {
        guard let budget = budget else { return }
        navigationItem.title = "\(budget.amount)"
    }
    
    // MARK: -  Actions
    @IBAction func doneButtonTapped(_ sender: Any) {
        guard let budget = budget else { return }
        BudgetController.shared.save(budget: budget)
        performSegue(withIdentifier: "toBudgetList", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchTableViewController" {
            
        }
    }

}
