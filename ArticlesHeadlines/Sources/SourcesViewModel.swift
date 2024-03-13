//
//  SourcesViewModel.swift
//  ArticlesHeadlines
//
//  Created by Shan Chen on 2024/3/7.
//

import Foundation
import Combine

final class SourcesViewModel {
    enum ViewState {
        case loading
        case success(sources: [Source])
        case error(message: String)
    }
    
    var numberOfRows: Int {
        sources.count
    }
    
    let title = "Sources"
    
    @Published private(set) var state: ViewState = .success(sources: [])
    private var selectedSourceIds: [String: Bool]
    private let newsStore: NewsStoreProtocol
    private var sourcesSubscription: AnyCancellable?
    
    private var sources: [Source] {
        guard case let .success(sources) = state else { return [] }
        return sources
    }
    
    init(newsStore: NewsStoreProtocol = NewsStore()) {
        self.newsStore = newsStore
        selectedSourceIds = newsStore.loadSelectedSourceIds()
    }
    
    func loadSources() {
        state = .loading
        sourcesSubscription = newsStore.sourcesPublisher()
            .sink(receiveCompletion: { [weak self] in
                guard
                    let self = self,
                    case .failure(let error) = $0
                else { return }
                self.state = .error(message: error.localizedDescription)
            }, receiveValue: { [weak self] in
                self?.state = .success(sources: $0)
            })
    }
    
    func sourceAtIndex(_ index: Int) -> Source? {
        sources[safe: index]
    }
    
    func isSourceSelected(atIndex index: Int) -> Bool {
        guard let source = sourceAtIndex(index) else { return false }
        return selectedSourceIds[source.id] != nil
    }
    
    func didChangeSelectionAtIndex(_ index: Int) {
        guard let source = sourceAtIndex(index) else { return }
        if selectedSourceIds[source.id] == nil {
            selectedSourceIds[source.id] = true
        } else {
            selectedSourceIds[source.id] = nil
        }
        newsStore.saveSelectedSourceIds(selectedSourceIds)
    }
}
