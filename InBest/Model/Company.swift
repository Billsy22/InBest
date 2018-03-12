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
    let name: String = ""
    let symbol: String
    
    // MARK: -  Constant keys
    private let SymbolKey = "Symbol"
    
    // MARK: -  Initializer
    
    init?(dictionary: [String: Any]) {
        guard let symbol = dictionary[SymbolKey] as? String else { return nil }
        
        self.symbol = symbol
    }
}
