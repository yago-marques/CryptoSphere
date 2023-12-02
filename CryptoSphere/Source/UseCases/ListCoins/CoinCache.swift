//
//  CoinCacheRepository.swift
//  CryptoSphere
//
//  Created by Yago Marques on 28/11/23.
//

import Foundation

protocol CoinCache {
    func saveInCacheIfNeeded(_ coins: [DisplayedCoin]) throws
    func tryFetchFromCache() throws -> [DisplayedCoin]
    func lastCacheMessage() throws -> String
}
