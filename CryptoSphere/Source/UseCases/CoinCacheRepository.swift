//
//  CoinCacheRepository.swift
//  CryptoSphere
//
//  Created by Yago Marques on 28/11/23.
//

import Foundation

protocol CoinCacheRepository {
    func saveInCacheIfNeeded(_ coins: [DisplayedCoin]) throws
    func tryFetchFromCatch() throws -> [DisplayedCoin]
}
