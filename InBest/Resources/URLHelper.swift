//
//  URLHelper.swift
//  InBest
//
//  Created by Taylor Bills on 3/20/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import Foundation

struct URLHelper {
    
    static func url(searchTerms: [String: String]?, to url: URL) -> URL {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = searchTerms?.compactMap{URLQueryItem(name: $0.0, value: $0.1)}
        
        guard let url = components?.url else {
            fatalError("Bad url \(#file) \(#function)")
        }
        return url
        
    }
}
