//
//  HeadlinesViewModel.swift
//  ArticlesHeadlines
//
//  Created by Shan Chen on 2024/3/7.
//

import Foundation
import Combine

final class HeadlinesViewModel {
    let title = "Headlines"
    
    var articlesViewModel: ArticlesViewModel {
        ArticlesViewModel(stateSubject: stateSubject)
    }
    
    private let stateSubject: CurrentValueSubject<ArticlesViewModel.ViewState, Never> = .init(.success(articles: []))
    private let newsStore: NewsStoreProtocol
    private var headlinesSubscription: AnyCancellable?

    init(newsStore: NewsStoreProtocol = NewsStore()) {
        self.newsStore = newsStore
    }
    
    func loadHeadlines() {
        stateSubject.send(.loading)
        headlinesSubscription = newsStore.headlinesPublisher()
            .sink(receiveCompletion: { [weak self] in
                guard
                    let self = self,
                    case .failure(let error) = $0
                else { return }
                self.stateSubject.send(.error(message: error.localizedDescription))
            }, receiveValue: { [weak self] in
                self?.stateSubject.send(.success(articles: $0))
            })
    }
}
