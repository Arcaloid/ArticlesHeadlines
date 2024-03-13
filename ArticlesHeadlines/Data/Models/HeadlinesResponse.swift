//
//  HeadlinesResponse.swift
//  ArticlesHeadlines
//
//  Created by Shan Chen on 2024/3/7.
//

import Foundation

struct HeadlinesResponse: Decodable {
    enum Status: String, Decodable {
        case ok, error
    }
    
    private enum CodingKeys: String, CodingKey {
        case status
        case articles
        case errorMessage = "message"
    }
    
    let status: Status
    let articles: [Article]?
    let errorMessage: String?
}
