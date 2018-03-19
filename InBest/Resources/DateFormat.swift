//
//  DateFormatter.swift
//  InBest
//
//  Created by Taylor Bills on 3/19/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import Foundation

class DateFormat {
    
    // MARK: -  Properties
    static let shared = DateFormat()
    
    // MARK: -  Format functions
    func formatDateFrom(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: string) else { return nil }
        return date
    }
    
    func formatDateFrom(date: Date) -> Date? {
        let dateAsString = "\(date)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: dateAsString) else { return nil }
        return date
    }
    
    func formatCurrentStockDateFrom(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        dateFormatter.timeZone = TimeZone(abbreviation: "EST")
        let myDate = dateFormatter.date(from: string)
        return myDate
    }
    
    func formatDateFrom(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}


