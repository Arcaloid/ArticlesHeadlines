//
//  NewsAPIEndpoint.swift
//  ArticlesHeadlines
//
//  Created by Shan Chen on 2024/3/7.
//

import Foundation

protocol NewsAPIEndpoint: APIEndpoint {}

extension NewsAPIEndpoint {
    var headers: [String : String] { ["X-Api-Key": "\(API.apiKey)"] }
}

struct NewsAPIError: LocalizedError {
    let message: String?
    
    var errorDescription: String? { message }
}
