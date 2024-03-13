//
//  SavedViewModel.swift
//  ArticlesHeadlines
//
//  Created by Shan Chen on 2024/3/8.
//

import Foundation
import Combine

final class SavedViewModel {
    let title = "Saved"
    
    var articlesViewModel: ArticlesViewModel {
        ArticlesViewModel(stateSubject: stateSubject)
    }
    
    private let stateSubject: CurrentValueSubject<ArticlesViewModel.ViewState, Never> = .init(.success(articles: []))
    private let newsStore: NewsStoreProtocol
    private var savedArticlesSubscription: AnyCancellable?
    
    init(newsStore: NewsStoreProtocol = NewsStore()) {
        self.newsStore = newsStore
    }
    
    func loadSavedArticles() {
        stateSubject.send(.loading)
        savedArticlesSubscription = newsStore.savedArticlesPublisher()
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
