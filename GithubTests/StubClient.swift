//
//  StubClient.swift
//  GithubTests
//
//  Created by 현진 on 2021/02/13.
//

import Foundation

import Apollo
import RxSwift

enum StubClientError: Error {
    case testableNotImplimented
}

final class StubClient: ApolloClientProtocol {
    
    var store: ApolloStore
    var cacheKeyForObject: CacheKeyForObject?
    
    init() {
        self.store = ApolloStore()
        self.cacheKeyForObject = store.cacheKeyForObject
    }
    
    func clearCache(callbackQueue: DispatchQueue, completion: ((Result<Void, Error>) -> Void)?) {
        store.clearCache(callbackQueue: callbackQueue, completion: completion)
    }
    
    func fetch<Query>(
        query: Query, cachePolicy: CachePolicy,
        contextIdentifier: UUID?,
        queue: DispatchQueue,
        resultHandler: GraphQLResultHandler<Query.Data>?
    ) -> Cancellable where Query : GraphQLQuery {
        guard let handler = resultHandler else {
            return EmptyCancellable()
        }
        guard let mocked = (query as? QueryTestable)?.mocked as? Query.Data else {
            handler(.failure(StubClientError.testableNotImplimented))
            return EmptyCancellable()
        }
        
        let result = GraphQLResult(
            data: mocked,
            extensions: nil,
            errors: [],
            source: .server,
            dependentKeys: nil
        )
        handler(.success(result))
        return EmptyCancellable()
    }
    
    func perform<Mutation>(
        mutation: Mutation,
        publishResultToStore: Bool,
        queue: DispatchQueue,
        resultHandler: GraphQLResultHandler<Mutation.Data>?
    ) -> Cancellable where Mutation : GraphQLMutation {
        guard let handler = resultHandler else {
            return EmptyCancellable()
        }
        guard let mocked = (mutation as? QueryTestable)?.mocked as? Mutation.Data else {
            handler(.failure(StubClientError.testableNotImplimented))
            return EmptyCancellable()
        }
        
        let result = GraphQLResult(
            data: mocked,
            extensions: nil,
            errors: [],
            source: .server,
            dependentKeys: nil
        )
        handler(.success(result))
        return EmptyCancellable()
    }
    
    func watch<Query>(
        query: Query,
        cachePolicy: CachePolicy,
        resultHandler: @escaping GraphQLResultHandler<Query.Data>
    ) -> GraphQLQueryWatcher<Query> where Query : GraphQLQuery {
        fatalError("ApolloClient.watch() is not testable")
    }
    
    func upload<Operation>(
        operation: Operation,
        files: [GraphQLFile],
        queue: DispatchQueue,
        resultHandler: GraphQLResultHandler<Operation.Data>?
    ) -> Cancellable where Operation : GraphQLOperation {
        fatalError("ApolloClient.upload() is not testable")
    }
    
    func subscribe<Subscription>(
        subscription: Subscription,
        queue: DispatchQueue,
        resultHandler: @escaping GraphQLResultHandler<Subscription.Data>
    ) -> Cancellable where Subscription : GraphQLSubscription {
        fatalError("ApolloClient.subscribe() is not testable")
    }
    
    
}
