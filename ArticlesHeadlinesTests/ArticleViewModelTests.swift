//
//  ArticleViewModelTests.swift
//  ArticlesHeadlinesTests
//
//  Created by Shan Chen on 2024/3/8.
//

import XCTest
@testable import ArticlesHeadlines

final class ArticleViewModelTests: XCTestCase {
    private var viewModel: ArticleViewModel!
    private var mockNewsStore: MockNewsStore!
    
    override func setUp() {
        super.setUp()
        mockNewsStore = MockNewsStore()
        let mockArticles: [Article] = MockUntils.loadMockResponse(jsonFile: "articles")
        viewModel = ArticleViewModel(article: mockArticles[0], newsStore: mockNewsStore)
    }
    
    func testArticleUrl() {
        XCTAssertEqual(viewModel.articleUrl.absoluteString, "https://news.google.com/rss/articles/CBMiX2h0dHBzOi8vd3d3Lm1vdG9yc3BvcnQtdG90YWwuY29tL2F1dG8vZm90b3MtdmlkZW9zL2ZvdG9zdHJlY2tlbi9maWF0LTUwMC10cmlidXRvLXRyZXBpdW5vLzExMDEz0gEA?oc=5")
    }
    
    func testSaveArticle() {
        mockNewsStore.mockIsArticleSaved = false
        viewModel.saveArticle()
        XCTAssertTrue(mockNewsStore.saveArticleCalled)
        XCTAssertTrue(viewModel.isSaved)
    }
    
    func testUnsaveArticle() {
        mockNewsStore.mockIsArticleSaved = true
        viewModel.unsaveArticle()
        XCTAssertTrue(mockNewsStore.deleteSavedArticleCalled)
        XCTAssertFalse(viewModel.isSaved)
    }
}
