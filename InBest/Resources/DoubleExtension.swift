//
//  DoubleExtension.swift
//  InBest
//
//  Created by Taylor Bills on 3/21/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import Foundation

extension Double {
    
    func roundedToMoney() -> Double {
        var largeNumber = self * 100
        largeNumber.round(.towardZero)
        let finalNumber = largeNumber / 100
        return finalNumber
    }
}
