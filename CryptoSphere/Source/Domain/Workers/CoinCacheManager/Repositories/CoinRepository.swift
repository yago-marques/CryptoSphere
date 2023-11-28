//
//  CoinRepository.swift
//  CryptoSphere
//
//  Created by Yago Marques on 28/11/23.
//

import Foundation

protocol CoinRepository {
    func coinsIsEmpty() throws -> Bool
    func saveCoins(_ coins: [DisplayedCoin]) throws
    func replaceCoins(for newCoins: [DisplayedCoin]) throws
    func readCoins() throws -> [DisplayedCoin]
}
