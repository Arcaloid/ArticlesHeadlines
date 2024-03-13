//
//  MockNewsStore.swift
//  ArticlesHeadlinesTests
//
//  Created by Shan Chen on 2024/3/8.
//

@testable import ArticlesHeadlines
import Combine

final class MockNewsStore: NewsStoreProtocol {
    var mockHeadlinesSubject = PassthroughSubject<[Article], Error>()
    func headlinesPublisher() -> AnyPublisher<[Article], Error> {
        mockHeadlinesSubject.eraseToAnyPublisher()
    }
    
    var mockSourcesSubject = PassthroughSubject<[Source], Error>()
    func sourcesPublisher() -> AnyPublisher<[Source], Error> {
        mockSourcesSubject.eraseToAnyPublisher()
    }
    
    var mockSelectedSourceIds = [String : Bool]()
    func loadSelectedSourceIds() -> [String : Bool] {
        mockSelectedSourceIds
    }
    
    var saveSelectedSourceIdsCalled = false
    func saveSelectedSourceIds(_ selectedSourceIds: [String : Bool]) {
        saveSelectedSourceIdsCalled = true
    }
    
    var mockIsArticleSaved = false
    func isArticleSaved(article: ArticlesHeadlines.NewsArticle) -> Bool {
        mockIsArticleSaved
    }
    
    var saveArticleCalled = false
    func saveArticle(_ article: ArticlesHeadlines.NewsArticle) throws {
        saveArticleCalled = true
    }
    
    var deleteSavedArticleCalled = false
    func deleteSavedArticle(article: ArticlesHeadlines.NewsArticle) throws {
        deleteSavedArticleCalled = true
    }
   
    @Published var mockSavedArticles = [NewsArticle]()
    func savedArticlesPublisher() -> AnyPublisher<[NewsArticle], Never> {
        $mockSavedArticles.eraseToAnyPublisher()
    }
}
