//
//  Environment.swift
//  Startup Creator
//
//  Created by Chris W on 1/10/25.
//

import Foundation

enum Environment {
    enum Keys {
        static let apiKey = "API_KEY"
    }
    
    private static let infoDictionary: [String:Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist file not found")
        }
        return dict
    }()
    
    static let apiKey: String = {
        guard let apiKeyString = Environment.infoDictionary[Keys.apiKey] as? String else {
            fatalError("Api key not set in plist")
        }
        return apiKeyString
    }()
}
