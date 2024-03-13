//
//  NewsStore.swift
//  ArticlesHeadlines
//
//  Created by Shan Chen on 2024/3/7.
//

import Foundation
import Combine

protocol NewsStoreProtocol {
    func headlinesPublisher() -> AnyPublisher<[Article], Error>
    func sourcesPublisher() -> AnyPublisher<[Source], Error>
    func loadSelectedSourceIds() -> [String: Bool]
    func saveSelectedSourceIds(_ selectedSourceIds: [String: Bool])
    func isArticleSaved(article: NewsArticle) -> Bool
    func saveArticle(_ article: NewsArticle) throws
    func deleteSavedArticle(article: NewsArticle) throws
    func savedArticlesPublisher() -> AnyPublisher<[NewsArticle], Never>
}

final class NewsStore: NewsStoreProtocol {
    private let apiClient: APIClientProtocol
    private let userDefaults: UserDefaults
    private let persistenceManager: PersistenceManager
    private let selectedSourcesKey = "selectedSourcesKey"
    
    init(
        apiClient: APIClientProtocol = APIClient(),
        userDefaults: UserDefaults = UserDefaults.standard,
        persistenceManager: PersistenceManager = PersistenceManager.shared
    ) {
        self.apiClient = apiClient
        self.userDefaults = userDefaults
        self.persistenceManager = persistenceManager
    }
    
    func headlinesPublisher() -> AnyPublisher<[Article], Error> {
        let selectedSourceIds = loadSelectedSourceIds().keys.joined(separator: ",")
        return apiClient
            .requestPublisher(HeadlinesResponse.self, endpoint: HeadlinesAPI(sources: selectedSourceIds))
            .tryMap { response in
                guard response.status == .ok else {
                    throw NewsAPIError(message: response.errorMessage)
                }
                return response.articles ?? []
            }
            .eraseToAnyPublisher()
    }
    
    func sourcesPublisher() -> AnyPublisher<[Source], Error> {
        apiClient
            .requestPublisher(SourcesResponse.self, endpoint: SourcesAPI())
            .tryMap { response in
                guard response.status == .ok else {
                    throw NewsAPIError(message: response.errorMessage)
                }
                return response.sources ?? []
            }
            .eraseToAnyPublisher()
    }
    
    // Store saved ids as dictionary to trade memory for search speed
    func loadSelectedSourceIds() -> [String: Bool] {
        (userDefaults.dictionary(forKey: selectedSourcesKey) as? [String: Bool]) ?? [:]
    }
    
    func saveSelectedSourceIds(_ selectedSourceIds: [String: Bool]) {
        userDefaults.set(selectedSourceIds, forKey: selectedSourcesKey)
    }
    
    func isArticleSaved(article: NewsArticle) -> Bool {
        let managedObjectContext = persistenceManager.viewContext
        return managedObjectContext.performAndWait {
            let fetchRequest = ArticleCache.fetchRequest()
            fetchRequest.resultType = .countResultType
            fetchRequest.predicate = NSPredicate(format: "url == %@", article.url as CVarArg)
            do {
                return try managedObjectContext.count(for: fetchRequest) > 0
            } catch {
                return false
            }
        }
    }
    
    func saveArticle(_ article: NewsArticle) throws {
        let managedObjectContext = persistenceManager.viewContext
        let articleCache = ArticleCache(context: managedObjectContext)
        articleCache.title = article.title
        articleCache.articleDescription = article.articleDescription
        articleCache.author = article.author
        articleCache.url = article.url
        articleCache.urlToImage = article.urlToImage
        try managedObjectContext.save()
    }
    
    func deleteSavedArticle(article: NewsArticle) throws {
        let managedObjectContext = persistenceManager.viewContext
        let fetchRequest = ArticleCache.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", article.url as CVarArg)
        try managedObjectContext.performAndWait {
            guard let articleCache = try fetchRequest.execute().first else { return }
            managedObjectContext.delete(articleCache)
            try managedObjectContext.save()
        }
    }
    
    func savedArticlesPublisher() -> AnyPublisher<[NewsArticle], Never> {
        let managedObjectContext = persistenceManager.backgroundContext
        return Future<[NewsArticle], Error> { promise in
            Task {
                do {
                    let cachedArticles = try await managedObjectContext.perform {
                        let fetchRequest = ArticleCache.fetchRequest()
                        return try fetchRequest.execute()
                    }
                    promise(.success(cachedArticles))
                } catch {
                    promise(.failure(error))
                }
            }
        }.catch { error -> AnyPublisher<[NewsArticle], Never> in
            Just([]).eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
}
