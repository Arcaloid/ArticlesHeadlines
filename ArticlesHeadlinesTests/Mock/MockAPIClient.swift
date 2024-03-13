//
//  MockAPIClient.swift
//  ArticlesHeadlinesTests
//
//  Created by Shan Chen on 2024/3/8.
//

import Combine
@testable import ArticlesHeadlines

final class MockAPIClient: APIClientProtocol {
    var mockResponse: Any!
    var mockError: Error!
    func request<T>(_ responseType: T.Type, endpoint: APIEndpoint, completion: @escaping (Result<T, Error>) -> ()) where T : Decodable {
        if let mockResponse {
            completion(.success(mockResponse as! T))
        } else if let mockError {
            completion(.failure(mockError))
        }
    }
    
    func request<T>(_ responseType: T.Type, endpoint: APIEndpoint) async throws -> T where T : Decodable {
        if let mockResponse {
            return mockResponse as! T
        } else {
            throw mockError
        }
    }
    
    func requestPublisher<T>(_ responseType: T.Type, endpoint: APIEndpoint) -> AnyPublisher<T, Error> where T : Decodable {
        if let mockResponse {
            return CurrentValueSubject(mockResponse as! T).eraseToAnyPublisher()
        } else {
            return Fail(error: mockError).eraseToAnyPublisher()
        }
    }
}
