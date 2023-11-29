//
//  CoinCacheManager.swift
//  CryptoSphere
//
//  Created by Yago Marques on 28/11/23.
//

import CoreData

struct CacheError: Error { }

struct CoinCacheManager: CoinCache {
    let coinRepository: CoinRepository
    let cacheVersionRepository: CacheVersionRepository

    func saveInCacheIfNeeded(_ coins: [DisplayedCoin]) throws {
        if let lastCacheDate = try cacheVersionRepository.getLastDate() {
            try updateCacheIfNeeded(for: lastCacheDate, coins)
        } else {
            try coinRepository.saveCoins(coins)
            try cacheVersionRepository.registerUpdate()
        }
    }

    func tryFetchFromCache() throws -> [DisplayedCoin] {
        if try coinRepository.coinsIsEmpty() {
            throw CacheError()
        } else {
            try coinRepository.readCoins()
        }
    }

    func lastCacheMessage() throws -> String {
        guard let lastDate = try cacheVersionRepository.getLastDate() else { return "invalid cache" }
        
        let calendar = Calendar.current

        let lastCacheHour = calendar.component(.hour, from: lastDate)
        let lastCacheDay = calendar.component(.day, from: lastDate)
        let lastCacheMonth = calendar.component(.month, from: lastDate)
        let lastCacheMinute = calendar.component(.minute, from: lastDate)

        return "connection error, this is a list saved in internal memory at \(lastCacheDay)/\(lastCacheMonth) - \(lastCacheHour):\(lastCacheMinute)"
    }

    private func updateCacheIfNeeded(for lastDate: Date, _ coins: [DisplayedCoin]) throws {
        if canResetCache(for: lastDate) {
            try coinRepository.replaceCoins(for: coins)
            try cacheVersionRepository.registerUpdate()
        }
    }

    private func canResetCache(for lastDate: Date) -> Bool {
        let curentDate = Date()
        let calendar = Calendar.current

        let currentHour = calendar.component(.hour, from: curentDate)
        let currentDay = calendar.component(.day, from: curentDate)

        let lastCachedHour = calendar.component(.hour, from: lastDate)
        let lastCachedDay = calendar.component(.day, from: lastDate)

        if lastCachedDay != currentDay {
            return true
        } else if lastCachedHour < currentHour {
            return true
        } else {
            return false
        }
    }
}
