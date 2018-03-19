//
//  SearchResultsController.swift
//  InBest
//
//  Created by Taylor Bills on 3/14/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import Foundation

class SearchResultsController {
    
    // MARK: -  Properties
    static let shared = SearchResultsController()
    var searchedCompanies: [Company] = []
    
    // MARK: -  CRUD
    func fetchCompanyInfoFor(searchTerm: String) {
        var companies: [Company] = []
        for company in CompanyController.shared.companyJsonLoaded {
            if company.name.lowercased().contains(searchTerm.lowercased()) || company.symbol.lowercased().contains(searchTerm.lowercased()) {
                companies.append(company)
            }
        }
        self.searchedCompanies = companies
    }
}
