//
//  ArticlesViewModelTests.swift
//  ArticlesHeadlinesTests
//
//  Created by Shan Chen on 2024/3/8.
//

import XCTest
import Combine
@testable import ArticlesHeadlines

final class ArticlesViewModelTests: XCTestCase {
    private var viewModel: ArticlesViewModel!
    private var stateSubject: CurrentValueSubject<ArticlesViewModel.ViewState, Never>!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        stateSubject = .init(.success(articles: []))
        viewModel = ArticlesViewModel(stateSubject: stateSubject)
        cancellables = []
    }
    
    func testLoadingState() {
        stateSubject.send(.loading)
        XCTAssertEqual(viewModel.numberOfRows, 0)
    }
    
    func testSuccessState() {
        let mockArticles: [Article] = MockUntils.loadMockResponse(jsonFile: "articles")
        stateSubject.send(.success(articles: mockArticles))
        XCTAssertEqual(viewModel.numberOfRows, 3)
        XCTAssertEqual(viewModel.articleAtIndex(0)?.title, "Fotostrecken - Motorsport-Total.com")
        XCTAssertEqual(viewModel.articleAtIndex(1)?.title, "Warnstreik: Heute keine Abflüge am Hamburger Airport - NDR.de")
        XCTAssertEqual(viewModel.articleAtIndex(2)?.title, "Autofrachter: „Felicity Ace“-Eigner verklagt Porsche auf Millionensumme - WELT")
    }
}
