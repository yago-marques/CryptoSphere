//
//  CoinRepositoryMock.swift
//  CryptoSphereTests
//
//  Created by Yago Marques on 03/12/23.
//

@testable import CryptoSphere
import Foundation

final class CoinRepositoryMock: CoinRepository {
    enum Message: Equatable {
        case saveCoinsCalled
        case replaceCoinsCalled
        case readCoinsCalled
    }

    var receivedMessages = [Message]()

    var coins: [DisplayedCoin] = []

    func populate() {
        coins = [
            .init(
                id: "1",
                name: "",
                marketRank: 1,
                image: Data(),
                dollarPrice: "s"
            ),
            .init(
                id: "2",
                name: "",
                marketRank: 1,
                image: Data(),
                dollarPrice: "s"
            )
        ]
    }

    func coinsIsEmpty() throws -> Bool {
        coins.isEmpty
    }
    
    func saveCoins(_ coins: [CryptoSphere.DisplayedCoin]) throws {
        receivedMessages.append(.saveCoinsCalled)
        self.coins = coins
    }
    
    func replaceCoins(for newCoins: [CryptoSphere.DisplayedCoin]) throws {
        receivedMessages.append(.replaceCoinsCalled)
        coins = newCoins
    }
    
    func readCoins() throws -> [CryptoSphere.DisplayedCoin] {
        receivedMessages.append(.readCoinsCalled)
        return coins
    }
}
