//
//  NewsStoreTests.swift
//  ArticlesHeadlinesTests
//
//  Created by Shan Chen on 2024/3/8.
//

import XCTest
import Combine
@testable import ArticlesHeadlines

final class NewsStoreTests: XCTestCase {
    private var store: NewsStore!
    private var mockApiClient: MockAPIClient!
    private var persistenceManager: PersistenceManager!
    private var mockUserDefaults: MockUserDefault!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockApiClient = MockAPIClient()
        persistenceManager = PersistenceManager(inMemory: true)
        mockUserDefaults = MockUserDefault()
        store = NewsStore(
            apiClient: mockApiClient,
            userDefaults: mockUserDefaults,
            persistenceManager: persistenceManager
        )
        cancellables = []
    }
    
    override func tearDown() {
        super.tearDown()
        persistenceManager.viewContext.reset()
        persistenceManager.backgroundContext.reset()
    }
    
    func testLoadHeadlines() {
        let mockHeadlinesResponse: HeadlinesResponse = MockUntils.loadMockResponse(jsonFile: "headlines_response")
        mockApiClient.mockResponse = mockHeadlinesResponse
        let expectation = expectation(description: "Load headlines")
        var loadedHeadlines: [Article]?
        store.headlinesPublisher().sink { _ in
            XCTFail("Load headlines should not fail")
        } receiveValue: {
            loadedHeadlines = $0
            expectation.fulfill()
        }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(loadedHeadlines?.count, 3)
    }
    
    func testLoadSources() {
        let mockSourcesResponse: SourcesResponse = MockUntils.loadMockResponse(jsonFile: "sources_response")
        mockApiClient.mockResponse = mockSourcesResponse
        let expectation = expectation(description: "Load sources")
        var loadedSources: [Source]?
        store.sourcesPublisher().sink { _ in
            XCTFail("Load headlines should not fail")
        } receiveValue: {
            loadedSources = $0
            expectation.fulfill()
        }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(loadedSources?.count, 3)
    }
    
    func testLoadSelectedSourceIds() {
        mockUserDefaults.persistedDictionary = ["abc": true]
        XCTAssertEqual(store.loadSelectedSourceIds(),  ["abc": true])
    }
    
    func testSaveSelectedSourceIds() {
        store.saveSelectedSourceIds(["abc": true])
        XCTAssertEqual(mockUserDefaults.persistedValue as? [String : Bool], ["abc": true])
    }
    
    func testSavingArticle() throws {
        let articles: [Article] = MockUntils.loadMockResponse(jsonFile: "articles")
        let article = articles[0]
        XCTAssertFalse(store.isArticleSaved(article: article))
        try store.saveArticle(article)
        XCTAssertTrue(store.isArticleSaved(article: article))
        try store.deleteSavedArticle(article: article)
        XCTAssertFalse(store.isArticleSaved(article: article))
    }
    
    func testLoadSavedArticles() throws {
        let articles: [Article] = MockUntils.loadMockResponse(jsonFile: "articles")
        try articles.forEach { [weak self] in
            try self?.store.saveArticle($0)
        }
        
        var savedArticles: [NewsArticle]?
        let expectation = expectation(description: "Load saved articles")
        store.savedArticlesPublisher().sink {
            savedArticles = $0
            expectation.fulfill()
        }.store(in: &cancellables)
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(savedArticles?.count, 3)
    }
}
