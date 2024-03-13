//
//  HeadlinesAPI.swift
//  ArticlesHeadlines
//
//  Created by Shan Chen on 2024/2/1.
//

import Foundation

struct HeadlinesAPI: NewsAPIEndpoint {
    let urlString: String = "https://newsapi.org/v2/top-headlines"
    let parameters: [String: String]

    init(sources: String) {
        parameters = ["sources": sources]
    }
}
