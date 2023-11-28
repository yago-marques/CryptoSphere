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
    let cacheVersionrepository: CacheVersionRepository

    func saveInCacheIfNeeded(_ coins: [DisplayedCoin]) throws {
        if let lastCacheDate = try cacheVersionrepository.getLastDate() {
            try updateCacheIfNeeded(for: lastCacheDate, coins)
        } else {
            try coinRepository.saveCoins(coins)
            try cacheVersionrepository.registerUpdate()
        }
    }

    func tryFetchFromCache() throws -> [DisplayedCoin] {
        try coinRepository.readCoins()
    }

    private func updateCacheIfNeeded(for lastDate: Date, _ coins: [DisplayedCoin]) throws {
        if canResetCache(for: lastDate) {
            try coinRepository.replaceCoins(for: coins)
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
