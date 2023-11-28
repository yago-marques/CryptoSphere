//
//  CoinMapper.swift
//  CryptoSphere
//
//  Created by Yago Marques on 27/11/23.
//

import Foundation

struct CoinMapper {
    static func toBusiness(from remote: RemoteCoinResult) -> Coin {
        .init(
            id: remote.item.id,
            name: remote.item.name,
            marketRank: remote.item.marketCapRank,
            imageUrl: remote.item.large,
            bitcoinPrice: remote.item.priceBtc
        )
    }

    static func toDisplayed(from business: Coin) -> DisplayedCoin {
        .init(
            id: business.id,
            name: business.name,
            marketRank: business.marketRank,
            imageUrl: business.imageUrl,
            bitcoinPrice: business.bitcoinPrice
        )
    }
}
