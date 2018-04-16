//
//  SearchCompanyTableViewCell.swift
//  InBest
//
//  Created by Taylor Bills on 4/16/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import UIKit

class SearchCompanyTableViewCell: UITableViewCell {
    
    // MARK: -  Properties
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companyTickerSymbolLabel: UILabel!
    var company: Company? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: -  Update Views
    func updateViews() {
        guard let company = company else { return }
        companyNameLabel.text = company.name
        companyTickerSymbolLabel.text = company.symbol
    }
}
