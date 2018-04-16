//
//  CustomLabelWrappingTableViewCell.swift
//  InBest
//
//  Created by Taylor Bills on 4/16/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import UIKit

class InvestmentTableViewCell: UITableViewCell {
    
    // MARK: -  Properties
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var investedAmountLabel: UILabel!
    var investment: Investment?
    var company: Company? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: -  Update views
    func updateViews() {
        guard let investment = investment, let company = company else { return }
        companyNameLabel.text = company.name
        print(investment.initialAmountOfMoney)
        investedAmountLabel.text = "Initial Investment: $\(investment.initialAmountOfMoney.roundedToMoney())"
    }
}
