//
//  Networking.swift
//  Github
//
//  Created by 현진 on 2021/02/13.
//

import Foundation

import Apollo
import RxSwift

class Networking {
    
    let client: ApolloClientProtocol
    init(client: ApolloClientProtocol) {
        self.client = client
    }
    
}


