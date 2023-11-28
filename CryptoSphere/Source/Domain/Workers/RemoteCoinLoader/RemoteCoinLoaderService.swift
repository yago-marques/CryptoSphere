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
    func getDollarExchangeRate() async throws -> Decimal {
        if let data = try await httpClient.request(endpoint: CoinGeckoEndpoint(path: "/api/v3/exchange_rates")) {
            let exchange = try CoinMapper().getCoinExchange(from: data)

            return exchange
        } else {
            throw APICallError.invalidResponse
        }
    }
    
    func fetchCoinList() async throws -> [Coin] {
        throw APICallError.invalidAuth
        if let data = try await httpClient.request(endpoint: CoinGeckoEndpoint(path: "/api/v3/search/trending")) {
            let coins = try CoinMapper().toBusiness(from: data)

            return coins
        } else {
            throw APICallError.invalidResponse
        }
    }
}
