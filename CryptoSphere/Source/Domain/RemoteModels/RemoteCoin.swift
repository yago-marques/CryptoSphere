//
//  RemoteCoin.swift
//  CryptoSphere
//
//  Created by Yago Marques on 27/11/23.
//

import Foundation

struct RemoteCoin: Decodable {
    let coins: [RemoteCoinResult]
}

struct RemoteCoinResult: Decodable {
    let item: RemoteCoinResultItem
}

struct RemoteCoinResultItem: Decodable {
    let id: String
    let name: String
    let marketCapRank: Int
    let large: String
    let priceBtc: Decimal
}
