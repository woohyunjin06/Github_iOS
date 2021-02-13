//
//  Networking+Rx.swift
//  Github
//
//  Created by 현진 on 2021/02/13.
//

import Foundation

import Apollo
import RxSwift

enum ApolloError: Error {
    case gqlErrors([Error])
}

extension Networking: ReactiveCompatible {}
extension Reactive where Base: Networking {
    
    func fetch<Query: GraphQLQuery>(
        query: Query,
        cachePolicy: CachePolicy = .returnCacheDataElseFetch,
        contextIdentifier: UUID? = nil,
        queue: DispatchQueue = DispatchQueue.main
    ) -> Maybe<Query.Data> {
        Maybe.create { observer -> Disposable in
            let cancellable = base.client.fetch(
                query: query,
                cachePolicy: cachePolicy,
                contextIdentifier: contextIdentifier,
                queue: queue
            ) { result in
                switch result {
                case .success(let result):
                    if let data = result.data {
                        observer(.success(data))
                    } else if let errors = result.errors {
                        observer(.error(ApolloError.gqlErrors(errors)))
                    }
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create {
                cancellable.cancel()
            }
        }
    }
    
    func perform<Mutation: GraphQLMutation>(
        mutation: Mutation,
        publishResultToStore: Bool = true,
        queue: DispatchQueue = .main
    ) -> Maybe<Mutation.Data> {
        Maybe.create { observer -> Disposable in
            let cancellable = base.client.perform(
                mutation: mutation,
                publishResultToStore: publishResultToStore,
                queue: queue
            ) { result in
                switch result {
                case .success(let result):
                    if let data = result.data {
                        observer(.success(data))
                    } else if let errors = result.errors {
                        observer(.error(ApolloError.gqlErrors(errors)))
                    }
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create {
                cancellable.cancel()
            }
        }
    }
    
}
