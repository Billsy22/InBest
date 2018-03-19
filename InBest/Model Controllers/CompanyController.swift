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
    // Save Company for investment
    func save(company: Company) {
        ckManager.saveRecordsToCloudKit(records: [company.asCKRecord], database: ckManager.publicDB, perRecordCompletion: nil) { (records, _, error) in
            if let error = error {
                print("Error Saving Company: \(error.localizedDescription)")
                return
            }
        }
    }
    
    // Load all companies json at the start
    func loadAllCompanies() {
        guard let path = Bundle.main.path(forResource: "AllExchanges", ofType: "json") else { return }
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
            self.companyJsonLoaded = companies
        } catch let error {
            print("Error Loading Company: \(error.localizedDescription)")
        }
        print(self.companyJsonLoaded.count)
        print("Companies Loaded")
    }
}
