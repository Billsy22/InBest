//
//  Company.swift
//  InBest
//
//  Created by Taylor Bills on 3/12/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import Foundation

struct Company: Decodable {
    
    // MARK: -  Properties
    let name: String
    let symbol: MetaDataDictionary
    let pricePoints: [TimeSeriesDailyDictionary]
    
    // MARK: -  JSON Parsing
    struct MetaDataDictionary: Decodable {
        
        // Property
        let symbol: String
        
        // CodingKeys
        private enum CodingKeys: String, CodingKey {
            case symbol = "Symbol"
        }
    }
    
    struct TimeSeriesDailyDictionary: Decodable {
        
        // Properties
        let open: String
        let close: String
        let high: String
        let low: String
        
        // CodingKeys
        private enum CodingKeys: String, CodingKey {
            case open
            case close
            case high
            case low
        }
    }
}
