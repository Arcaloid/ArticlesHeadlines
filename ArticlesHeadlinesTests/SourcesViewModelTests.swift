//
//  SourcesViewModelTests.swift
//  ArticlesHeadlinesTests
//
//  Created by Shan Chen on 2024/3/8.
//

import XCTest
import Combine
@testable import ArticlesHeadlines

final class SourcesViewModelTests: XCTestCase {
    private var viewModel: SourcesViewModel!
    private var mockNewsStore: MockNewsStore!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockNewsStore = MockNewsStore()
        mockNewsStore.mockSelectedSourceIds = ["abc-news": true]
        viewModel = SourcesViewModel(newsStore: mockNewsStore)
        cancellables = []
    }
    
    func testTitle() {
        XCTAssertEqual(viewModel.title, "Sources")
    }
    
    func testLoadSources() {
        let expectation = expectation(description: "Sources loaded")
        var viewStates = [SourcesViewModel.ViewState]()
        viewModel.$state.dropFirst().sink {
            viewStates.append($0)
            if case .success = $0 {
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        viewModel.loadSources()
        let mockSources: [Source] = MockUntils.loadMockResponse(jsonFile: "sources")
        mockNewsStore.mockSourcesSubject.send(mockSources)
        
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(viewStates.count, 2)
        if case .loading = viewStates[0] {}
        else {
            XCTFail("Loading state missing")
        }
        
        if case let .success(sources) = viewStates[1] {
            XCTAssertEqual(sources.count, 3)
        } else {
            XCTFail("Success state missing")
        }
        
        XCTAssertEqual(viewModel.numberOfRows, 3)
        XCTAssertTrue(viewModel.isSourceSelected(atIndex: 0))
        XCTAssertFalse(viewModel.isSourceSelected(atIndex: 1))
        XCTAssertFalse(viewModel.isSourceSelected(atIndex: 2))
        XCTAssertEqual(viewModel.sourceAtIndex(0)?.name, "ABC News")
        XCTAssertEqual(viewModel.sourceAtIndex(1)?.name, "ABC News (AU)")
        XCTAssertEqual(viewModel.sourceAtIndex(2)?.name, "Aftenposten")
    }
    
    func testSelectSource() {
        let expectation = expectation(description: "Sources loaded")
        viewModel.$state.dropFirst().sink {
            if case .success = $0 {
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        viewModel.loadSources()
        let mockSources: [Source] = MockUntils.loadMockResponse(jsonFile: "sources")
        mockNewsStore.mockSourcesSubject.send(mockSources)
        wait(for: [expectation], timeout: 1)
        
        XCTAssertFalse(viewModel.isSourceSelected(atIndex: 1))
        viewModel.didChangeSelectionAtIndex(1)
        XCTAssertTrue(viewModel.isSourceSelected(atIndex: 1))
        XCTAssertTrue(mockNewsStore.saveSelectedSourceIdsCalled)
    }
    
    func testDeselectSource() {
        let expectation = expectation(description: "Sources loaded")
        viewModel.$state.dropFirst().sink {
            if case .success = $0 {
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        viewModel.loadSources()
        let mockSources: [Source] = MockUntils.loadMockResponse(jsonFile: "sources")
        mockNewsStore.mockSourcesSubject.send(mockSources)
        wait(for: [expectation], timeout: 1)
        
        XCTAssertTrue(viewModel.isSourceSelected(atIndex: 0))
        viewModel.didChangeSelectionAtIndex(0)
        XCTAssertFalse(viewModel.isSourceSelected(atIndex: 0))
        XCTAssertTrue(mockNewsStore.saveSelectedSourceIdsCalled)
    }
}
