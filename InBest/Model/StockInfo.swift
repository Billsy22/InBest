//
//  Dates.swift
//  InBest
//
//  Created by Taylor Bills on 3/12/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import Foundation

class StockInfo {
    
    // MARK: -  Properties
    let dateString: String
    let high: String
    let low: String
    let open: String
    let close: String
    
    var date: Date {
        guard let date = DateFormat.shared.formatDateFrom(string: dateString) else { return Date() }
        return date
    }
    
    // MARK: -  Keys
    private let HighKey = "2. high"
    private let LowKey = "3. low"
    private let OpenKey = "1. open"
    private let CloseKey = "4. close"
    
    // MARK: -  Initializer
    init?(date: String, dictionary: [String: Any]) {
        guard let high = dictionary[HighKey] as? String,
            let low = dictionary[LowKey] as? String,
            let open = dictionary[OpenKey] as? String,
            let close = dictionary[CloseKey] as? String else { return nil }
        
        self.dateString = date
        self.high = high
        self.low = low
        self.open = open
        self.close = close
    }
}
