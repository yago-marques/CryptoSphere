//
//  CoinLoader.swift
//  CryptoSphere
//
//  Created by Yago Marques on 27/11/23.
//

import Foundation

protocol CoinLoader {
    func fetchCoinList() async throws -> [Coin]
    func getDollarExchangeRate() async throws -> Decimal
}
