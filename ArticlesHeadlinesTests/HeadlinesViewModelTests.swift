//
//  HeadlinesViewModelTests.swift
//  ArticlesHeadlinesTests
//
//  Created by Shan Chen on 2024/3/8.
//

import XCTest
import Combine
@testable import ArticlesHeadlines

final class HeadlinesViewModelTests: XCTestCase {
    private var viewModel: HeadlinesViewModel!
    private var mockNewsStore: MockNewsStore!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockNewsStore = MockNewsStore()
        viewModel = HeadlinesViewModel(newsStore: mockNewsStore)
        cancellables = []
    }
    
    func testTitle() {
        XCTAssertEqual(viewModel.title, "Headlines")
    }
    
    func testArticlesViewState() {
        let articlesViewModel = viewModel.articlesViewModel
        let expectation = expectation(description: "View state changed")
        var viewStates = [ArticlesViewModel.ViewState]()
        articlesViewModel.stateSubject.dropFirst().sink {
            viewStates.append($0)
            if case .success = $0 {
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        viewModel.loadHeadlines()
        let mockArticles: [Article] = MockUntils.loadMockResponse(jsonFile: "articles")
        mockNewsStore.mockHeadlinesSubject.send(mockArticles)
        
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(viewStates.count, 2)
        if case .loading = viewStates[0] {}
        else {
            XCTFail("Loading state missing")
        }
        
        if case let .success(articles) = viewStates[1] {
            XCTAssertEqual(articles.count, 3)
        } else {
            XCTFail("Success state missing")
        }
    }
}
