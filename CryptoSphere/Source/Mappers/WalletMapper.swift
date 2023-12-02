//
//  WalletMapper.swift
//  CryptoSphere
//
//  Created by Yago Marques on 02/12/23.
//

import Foundation

struct WalletMapper {
    static func toDict(from business: Wallet, ownerToken: String) -> [String: Any] {
        [
            "id": business.id,
            "name": business.name,
            "image": business.image,
            "coins": business.coins,
            "owner": ownerToken
        ]
    }

    static func toUpdatedDict(from business: Wallet) -> [String: Any] {
        [
            "name": business.name,
            "image": business.image,
            "coins": business.coins,
        ]
    }

    static func toBusiness(from dict: [String: Any]) -> Wallet? {
        guard
            let id = dict["id"] as? String,
            let name = dict["name"] as? String,
            let image = dict["image"] as? String,
            let coins = dict["coins"] as? [String]
        else { return nil }

        return .init(id: id, name: name, image: image, coins: coins)
    }

    static func toDisplayed(from business: Wallet) -> DisplayedWallet {
        .init(
            id: business.id,
            name: business.name,
            image: business.image,
            coins: business.coins
        )
    }

}
