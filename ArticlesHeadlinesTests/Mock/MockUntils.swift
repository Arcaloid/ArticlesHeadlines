//
//  MockUntils.swift
//  ArticlesHeadlinesTests
//
//  Created by Shan Chen on 2024/3/8.
//

import Foundation

enum MockUntils {
    static func loadMockResponse<T: Decodable>(jsonFile: String) -> T {
        let path = Bundle(for: MockClass.self).path(
            forResource: jsonFile, ofType: "json"
        )!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        return try! JSONDecoder().decode(T.self, from: data)
    }
}

private final class MockClass {}
