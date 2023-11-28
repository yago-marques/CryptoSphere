//
//  CoinCacheManager.swift
//  CryptoSphere
//
//  Created by Yago Marques on 28/11/23.
//

import CoreData

struct CacheError: Error { }

struct CoinCacheManager: CoinCacheRepository {
    func saveInCacheIfNeeded(_ coins: [DisplayedCoin]) throws {

    }

    func tryFetchFromCatch() throws -> [DisplayedCoin] {
        []
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

private extension CoinCacheManager {
    
}
