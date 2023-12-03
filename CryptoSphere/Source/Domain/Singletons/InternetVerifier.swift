//
//  InternetVerifier.swift
//  CryptoSphere
//
//  Created by Yago Marques on 03/12/23.
//

import Foundation

struct InternetVerifier: VerifyConnection {
    static let shared = InternetVerifier()

    private init() { }

    func verifyConnection() async throws {
        let (_, _) = try await URLSession
            .shared
            .data(from: .init(string: "https://api.coingecko.com/api/v3/ping")!)
    }
}
