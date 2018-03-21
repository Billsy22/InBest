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
    func convertDateFrom(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: string) else { return nil }
        return date
    }
    
    func format(date: Date) -> Date? {
        let dateFormatterSet = DateFormatter()
        dateFormatterSet.dateFormat = "MMMM dd, yyyy"
        let dateAsString = "\(date)"
        guard let formattedDate = dateFormatterSet.date(from: dateAsString) else { return nil }
        return formattedDate
    }
    
    func formatCurrentStockDateFrom(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myDate = dateFormatter.date(from: string)
        return myDate
    }
    
    func convert(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
}


