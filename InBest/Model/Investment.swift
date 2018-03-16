//
//  Investment.swift
//  InBest
//
//  Created by Taylor Bills on 3/15/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import Foundation

class Investment {
    
    // MARK: -  Properties
    let company: Company
    let initialAmountOfMoney: Double
    var currentAmount: Double
    var numberOfShares: Double
    
    // MARK: -  Initializer
    init(company: Company, initialAmountOfMoney: Double, numberOfShares: Double) {
        self.company = company
        self.initialAmountOfMoney = initialAmountOfMoney
        self.currentAmount = initialAmountOfMoney
        self.numberOfShares = numberOfShares
    }
}

extension Investment: Equatable {
    static func ==(lhs: Investment, rhs: Investment) -> Bool {
        return lhs.company == rhs.company &&
        lhs.initialAmountOfMoney == rhs.initialAmountOfMoney &&
        lhs.numberOfShares == rhs.numberOfShares
    }
}
