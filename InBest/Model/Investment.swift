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
    var amountOfMoney: Double
    var numberOfShares: Double
    
    // MARK: -  Initializer
    init(company: Company, amountOfMoney: Double, numberOfShares: Double) {
        self.company = company
        self.amountOfMoney = amountOfMoney
        self.numberOfShares = numberOfShares
    }
}

extension Investment: Equatable {
    static func ==(lhs: Investment, rhs: Investment) -> Bool {
        return lhs.company == rhs.company &&
        lhs.amountOfMoney == rhs.amountOfMoney &&
        lhs.numberOfShares == rhs.numberOfShares
    }
}
