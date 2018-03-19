//
//  NetworkController.swift
//  InBest
//
//  Created by Taylor Bills on 3/15/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import Foundation

class StockInfoController {
    
    // MARK: -  Properties
    static let shared = StockInfoController()
    var company: Company?
    var stockInfo: [StockInfo] = []
    let baseURL = URL(string: "https://www.alphavantage.co/query")
    let apiKey = "S4O23N9DGVQMZCNP"
    
    // MARK: -  Fetch Stock Info
    // Week View
    func fetchLastWeeksStockInfoFor(symbol: String, completion: @escaping() -> Void) {
        guard let baseURL = baseURL else { return }
        let lastWeekStockTypeQuery = URLQueryItem(name: "function", value: "TIME_SERIES_DAILY")
        let companySymbolQuery = URLQueryItem(name: "symbol", value: symbol)
        let apiKeyQuery = URLQueryItem(name: "apikey", value: apiKey)
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        components?.queryItems = [lastWeekStockTypeQuery, companySymbolQuery, apiKeyQuery]
        guard let url = components?.url else { return }
        print(url)
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            do {
                if let error = error {
                    print("Error fetching last weeks stock information: \(error.localizedDescription)")
                    completion()
                    return
                }
                guard let data = data else {
                    completion()
                    return
                }
                guard let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                    completion()
                    return
                }
                guard let dailyDictionary = jsonDictionary["Time Series (Daily)"] as? [String: [String: Any]] else {
                    completion()
                    return
                }
                var daysArray: [StockInfo] = []
                for (date, dictionary) in dailyDictionary {
                    guard let stockInfo = StockInfo(date: date, dictionary: dictionary) else { return }
                    daysArray.append(stockInfo)
                }
                daysArray.sort(by: { $0.date > $1.date })
                var dayCounter = 0
                var pulledStockInfo: [StockInfo] = []
                for stockInfo in daysArray {
                    if dayCounter < 7 {
                        pulledStockInfo.append(stockInfo)
                        dayCounter += 1
                    } else {
                        break
                    }
                }
                self.stockInfo = pulledStockInfo
                completion()
            } catch let error {
                print("Error parsing last weeks stock info: \(error.localizedDescription) *** \(error) ***")
                completion()
            }
            
            }.resume()
    }
    
    // Latest Price
    func fetchCurrentStockInfoFor(symbol: String, completion: @escaping() -> Void) {
        guard let baseURL = baseURL else { return }
        let lastWeekStockTypeQuery = URLQueryItem(name: "function", value: "TIME_SERIES_INTRADAY")
        let companySymbolQuery = URLQueryItem(name: "symbol", value: symbol)
        let intervalQuery = URLQueryItem(name: "interval", value: "1min")
        let apiKeyQuery = URLQueryItem(name: "apikey", value: apiKey)
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        components?.queryItems = [lastWeekStockTypeQuery, companySymbolQuery, intervalQuery, apiKeyQuery]
        guard let url = components?.url else { return }
        print(url)
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            do {
                if let error = error {
                    print("Error fetching stock information: \(error.localizedDescription)")
                    completion()
                    return
                }
                guard let data = data else {
                    completion()
                    return
                }
                guard let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                    completion()
                    return
                }
                guard let dailyDictionary = jsonDictionary["Time Series (1min)"] as? [String: [String: Any]] else {
                    completion()
                    return
                }
                var daysArray: [StockInfo] = []
                for (date, dictionary) in dailyDictionary {
                    
                    guard stockInfo = StockInfo(date: formattedDate, dictionary: dictionary) else { return }
                    daysArray.append(stockInfo)
                }

                let sortedArray: [StockInfo] = daysArray.sorted(by: { $0.date < $1.date } )
                var dayCounter = 0
                var pulledStockInfo: [StockInfo] = []
                for stockInfo in sortedArray {
                    if dayCounter < 1 {
                        pulledStockInfo.append(stockInfo)
                        dayCounter += 1
                    } else {
                        break
                    }
                }
                self.stockInfo = daysArray
                completion()
            } catch let error {
                print("Error parsing current stock info: \(error.localizedDescription)")
                completion()
            }
            
            }.resume()
    }
}
