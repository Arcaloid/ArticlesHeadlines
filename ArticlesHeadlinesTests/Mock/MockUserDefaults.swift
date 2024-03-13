//
//  MockUserDefaults.swift
//  ArticlesHeadlinesTests
//
//  Created by Shan Chen on 2024/3/8.
//

import Foundation

final class MockUserDefault: UserDefaults {
    var persistedValue: Any?
    var persistenceKey: String?
    override func set(_ value: Any?, forKey defaultName: String) {
        persistedValue = value
        persistenceKey = defaultName
    }
    
    var persistedDictionary: [String : Any]?
    override func dictionary(forKey defaultName: String) -> [String : Any]? {
        persistedDictionary
    }
}
