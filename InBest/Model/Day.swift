//
//  Dates.swift
//  InBest
//
//  Created by Taylor Bills on 3/12/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import Foundation

class Day {
    
    // MARK: -  Properties
    let date: String
    let high: String
    let low: String
    let open: String
    let close: String
    
    // MARK: -  Keys
    private let HighKey = "high"
    private let LowKey = "low"
    private let OpenKey = "open"
    private let CloseKey = "close"
    
    // MARK: -  Initializer
    init?(date: String, dictionary: [String: Any]) {
        guard let high = dictionary[HighKey] as? String,
        let low = dictionary[LowKey] as? String,
            let open = dictionary[OpenKey] as? String,
            let close = dictionary[CloseKey] as? String else { return nil }
        
        self.date = date
        self.high = high
        self.low = low
        self.open = open
        self.close = close
    }
}
