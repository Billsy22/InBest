//
//  Company.swift
//  InBest
//
//  Created by Taylor Bills on 3/12/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import Foundation

class Company {
    
    // MARK: -  Properties
    let name: String
    let symbol: String
    
    // MARK: -  Initializer
    init?(symbol: String, dictionary: [String: Any]) {
        guard let name = dictionary["Name"] as? String else { return nil }
        self.symbol = symbol
        self.name = name
    }
}

extension Company: Equatable {
    static func ==(lhs: Company, rhs: Company) -> Bool {
        return lhs.name == rhs.name &&
        lhs.symbol == rhs.symbol
    }
}
