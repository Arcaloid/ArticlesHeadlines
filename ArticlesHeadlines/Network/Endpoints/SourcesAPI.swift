//
//  SourcesAPI.swift
//  ArticlesHeadlines
//
//  Created by Shan Chen on 2024/2/1.
//

import Foundation

struct SourcesAPI: NewsAPIEndpoint {
    let urlString: String = "https://newsapi.org/v2/top-headlines/sources"
    let parameters: [String: String] = ["language": "en"]
}
