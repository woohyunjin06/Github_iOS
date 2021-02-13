//
//  QueryTestable.swift
//  GithubTests
//
//  Created by 현진 on 2021/02/13.
//

import Foundation

import Apollo

protocol QueryTestable {
    let mocked: GraphQLSelectionSet { get }
}
