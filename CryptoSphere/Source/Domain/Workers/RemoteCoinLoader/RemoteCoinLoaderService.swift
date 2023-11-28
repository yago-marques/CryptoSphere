//
//  RemoteCoinLoader.swift
//  CryptoSphere
//
//  Created by Yago Marques on 27/11/23.
//

import Foundation

struct RemoteCoinLoaderService {
    let httpClient: HTTPClient
}

extension RemoteCoinLoaderService: CoinLoader {
    func fetchCoinList() async throws -> [Coin] {
        if let data = try await httpClient.request(endpoint: CoinListEndEndpoint()) {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let payload = try decoder.decode(RemoteCoin.self, from: data)
            let coins = payload.coins.map { CoinMapper.toBusiness(from: $0) }

            return coins
        } else {
            throw APICallError.invalidResponse
        }
    }
}
