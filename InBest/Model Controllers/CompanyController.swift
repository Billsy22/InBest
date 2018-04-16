//
//  CompanyController.swift
//  InBest
//
//  Created by Taylor Bills on 3/14/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import Foundation

class CompanyController {
    
    // MARK: -  Properties
    static let shared = CompanyController()
    let ckManager = CloudKitManager()
    var companyJsonLoaded: [Company] = []
    
    // MARK: -  CRUD
    
    // Load all companies json at the start
    func loadAllCompanies() {
        guard let path = Bundle.main.path(forResource: "All Exchanges", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            guard let companiesDictionary = json as? [String: [String: Any]] else { return }
            var companies: [Company] = []
            for (symbol, dictionary) in companiesDictionary {
                guard let company = Company(symbol: symbol, dictionary: dictionary) else { return }
                companies.append(company)
            }
            for company in companies {
                if company.symbol.contains("^") || company.symbol.contains(".") || company.symbol.contains("$") {
                    guard let index = companies.index(of: company) else { return }
                    companies.remove(at: index)
                }
            }
            self.companyJsonLoaded = companies
        } catch let error {
            print("Error Loading Company: \(error.localizedDescription)")
        }
        print(self.companyJsonLoaded.count)
        print("Companies Loaded")
    }
}
