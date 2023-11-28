//
//  CoinMapper.swift
//  CryptoSphere
//
//  Created by Yago Marques on 27/11/23.
//

import Foundation
import CoreData

struct CoinMapper {
    let decoder: JSONDecoder

    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func toBusiness(from data: Data) throws -> [Coin] {
        let payload = try decoder.decode(RemoteCoin.self, from: data)
        let remotes = payload.coins

        let coins = remotes.map { remote -> Coin in
            return .init(
                id: remote.item.id,
                name: remote.item.name,
                marketRank: remote.item.marketCapRank,
                imageUrl: remote.item.large,
                bitcoinPrice: remote.item.priceBtc
            )
        }

        return coins
    }

    func getCoinExchange(from data: Data) throws -> Decimal {
        let remoteExchange = try decoder.decode(RemoteExchange.self, from: data)

        guard let usdExchange = remoteExchange.rates["usd"] else { throw APICallError.invalidResponse }

        return usdExchange.value
    }

    static func toDisplayed(from business: Coin, exchange: Decimal) -> DisplayedCoin {
        .init(
            id: business.id,
            name: business.name,
            marketRank: business.marketRank,
            imageUrl: business.imageUrl,
            dollarPrice: NSDecimalNumber(
                decimal: business.bitcoinPrice * exchange
            ).stringValue
        )
    }

    static func toDisplayed(from local: CoinEntity) -> DisplayedCoin {
        .init(
            id: local.id ?? "",
            name: local.name ?? "",
            marketRank: Int(local.marketRank),
            imageUrl: local.imageUrl ?? "",
            dollarPrice: local.dollarPrice ?? ""
        )
    }

    static func toCached(from displayed: DisplayedCoin, context: NSManagedObjectContext) -> CoinEntity {
        let entity = CoinEntity(context: context)
        entity.id = displayed.id
        entity.name = displayed.name
        entity.imageUrl = displayed.imageUrl
        entity.dollarPrice = displayed.dollarPrice
        entity.marketRank = Int64(displayed.marketRank)

        return entity
    }
}
