//
//  ArticleViewModel.swift
//  ArticlesHeadlines
//
//  Created by Shan Chen on 2024/3/7.
//

import Foundation

final class ArticleViewModel {
    private let article: NewsArticle
    private let newsStore: NewsStoreProtocol
    
    var articleUrl: URL {
        article.url
    }
    
    @Published private(set) var isSaved: Bool
    @Published private(set) var error: Error?
    
    init(article: NewsArticle, newsStore: NewsStoreProtocol = NewsStore()) {
        self.article = article
        self.newsStore = newsStore
        isSaved = newsStore.isArticleSaved(article: article)
    }
    
    func saveArticle() {
        do {
            try newsStore.saveArticle(article)
            isSaved = true
        } catch {
            self.error = error
        }
    }
    
    func unsaveArticle() {
        do {
            try newsStore.deleteSavedArticle(article: article)
            isSaved = false
        } catch {
            self.error = error
        }
    }
}
