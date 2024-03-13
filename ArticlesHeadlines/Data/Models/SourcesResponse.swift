//
//  SourcesResponse.swift
//  ArticlesHeadlines
//
//  Created by Shan Chen on 2024/3/7.
//

import Foundation

struct SourcesResponse: Decodable {
    enum Status: String, Decodable {
        case ok, error
    }
    
    private enum CodingKeys: String, CodingKey {
        case status
        case sources
        case errorMessage = "message"
    }
    
    let status: Status
    let sources: [Source]?
    let errorMessage: String?
}
