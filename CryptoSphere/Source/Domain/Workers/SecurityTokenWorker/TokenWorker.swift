//
//  KeychainWorker.swift
//  CryptoSphere
//
//  Created by Yago Marques on 30/11/23.
//

import Foundation

typealias InternalSecurity = ReadToken & RegisterToken

struct TokenWorker: InternalSecurity {
    let repository: KeychainRepository

    func registerToken() throws {
        do {
            _ = try readToken()
        } catch {
            try repository.create(
                token: UUID().uuidString.data(using: .utf8) ?? Data(),
                service: "cryptosphere",
                account: "cryptosphere@gmail.com"
            )
        }

    }

    func readToken() throws -> String {
        try repository.read(
            service: "cryptosphere",
            account: "cryptosphere@gmail.com"
        )
    }
}
