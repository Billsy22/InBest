//
//  SearchTableViewController.swift
//  InBest
//
//  Created by Taylor Bills on 3/13/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    // MARK: -  Properties
    var budget: Budget?
    @IBOutlet weak var companySearchBar: UISearchBar!
    
    // MARK: -  Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        companySearchBar.delegate = self
        guard let budget = budget else { return }
        navigationItem.title = "\(budget.initialAmount)"
    }
    
    // MARK: -  SearchBar Delegate Method
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = companySearchBar.text?.lowercased(), !searchTerm.isEmpty else { return }
        SearchResultsController.shared.fetchCompanyInfoFor(searchTerm: searchTerm)
        companySearchBar.text = ""
        companySearchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchResultsController.shared.searchedCompanies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "companyCell", for: indexPath)
        let company = SearchResultsController.shared.searchedCompanies[indexPath.row]
        cell.textLabel?.text = company.name
        cell.detailTextLabel?.text = company.symbol
        return cell
    }
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCompanyInfo" {
            guard let companyInfoVC = segue.destination as? StockInfoViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let company = SearchResultsController.shared.searchedCompanies[indexPath.row]
            guard let budget = self.budget else { return }
            companyInfoVC.company = company
            companyInfoVC.budget = budget
        }
     }
}
