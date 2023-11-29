//
//  ListCoinsFallback.swift
//  CryptoSphere
//
//  Created by Yago Marques on 29/11/23.
//

import Foundation

protocol ListCoinsFallbackProtocol {
    func primary() async throws -> [DisplayedCoin]
    func secondary() throws -> ([DisplayedCoin], String)
}

struct ListCoinsFallback: ListCoinsFallbackProtocol {
    let coinLoader: CoinLoader
    let cacheManager: CoinCache

    func primary() async throws -> [DisplayedCoin] {
        let businessCoins = try await coinLoader.fetchCoinList()
        let exchange = try await coinLoader.getDollarExchangeRate()
        let coins = businessCoins.map { CoinMapper.toDisplayed(from: $0, exchange: exchange) }
        try cacheManager.saveInCacheIfNeeded(coins)

        return coins
    }
    
    func secondary() throws -> ([DisplayedCoin], String) {
        let cachedCoins = try cacheManager.tryFetchFromCache()
        let cacheMessage = try cacheManager.lastCacheMessage()

        return (cachedCoins, cacheMessage)
    }
}
