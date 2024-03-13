//
//  ArticlesViewModel.swift
//  ArticlesHeadlines
//
//  Created by Shan Chen on 2024/3/8.
//

import Foundation
import Combine

final class ArticlesViewModel {
    enum ViewState {
        case loading
        case success(articles: [NewsArticle])
        case error(message: String)
    }
    
    var numberOfRows: Int {
        articles.count
    }

    private(set) var stateSubject: CurrentValueSubject<ViewState, Never>
    private var cancellables = Set<AnyCancellable>()
    
    private var articles: [NewsArticle] {
        guard case let .success(articles) = stateSubject.value else { return [] }
        return articles
    }
    
    init(stateSubject: CurrentValueSubject<ViewState, Never>) {
        self.stateSubject = stateSubject
    }
    
    func articleAtIndex(_ index: Int) -> NewsArticle? {
        articles[safe: index]
    }
}
