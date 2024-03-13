//
//  HomeTabBarViewModelTests.swift
//  ArticlesHeadlinesTests
//
//  Created by Shan Chen on 2024/3/8.
//

import XCTest
@testable import ArticlesHeadlines

final class HomeTabBarViewModelTests: XCTestCase {
    private var viewModel: HomeTabBarViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = HomeTabBarViewModel()
    }
    
    func testTabs() {
        let tabs: [HomeTabBarViewModel.Tab] = [.headlines, .sources, .saved]
        XCTAssertEqual(viewModel.tabs, tabs)
    }
    
    func testViewControllers() {
        XCTAssertTrue(viewModel.viewController(forTab: .headlines) is HeadlinesViewController)
        XCTAssertTrue(viewModel.viewController(forTab: .sources) is SourcesViewController)
        XCTAssertTrue(viewModel.viewController(forTab: .saved) is SavedViewController)
    }
    
    func testTabBarItems() {
        XCTAssertEqual(viewModel.tabBarItem(forTab: .headlines).title, "Headlines")
        XCTAssertEqual(viewModel.tabBarItem(forTab: .sources).title, "Sources")
        XCTAssertEqual(viewModel.tabBarItem(forTab: .saved).title, "Saved")
    }
}
