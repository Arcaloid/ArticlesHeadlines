//
//  Article.swift
//  ArticlesHeadlines
//
//  Created by Shan Chen on 2024/3/7.
//

import Foundation

protocol NewsArticle {
    var title: String { get }
    var articleDescription: String? { get }
    var author: String? { get }
    var url: URL { get }
    var urlToImage: URL? { get }
}

struct Article: Decodable, NewsArticle {
    let title: String
    let articleDescription: String?
    let author: String?
    let url: URL
    let urlToImage: URL?
    
    private enum CodingKeys: String, CodingKey {
        case title
        case articleDescription = "description"
        case author
        case url
        case urlToImage
    }
}

extension ArticleCache: NewsArticle {}
