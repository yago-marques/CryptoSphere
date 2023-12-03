//
//  ListCoinsFallbackSpy.swift
//  CryptoSphereTests
//
//  Created by Yago Marques on 03/12/23.
//

@testable import CryptoSphere
import Foundation

struct ListCoinsFallbackSpyError: Error {}

final class ListCoinsFallbackSpy: ListCoinsFallbackProtocol {
    enum Message: Equatable {
        case primaryCalled
        case secondaryCalled
    }
    var internetActivated = true
    var cachePopulated = true
    let coins: [DisplayedCoin] = [.init(id: "", name: "", marketRank: 1, image: Data(), dollarPrice: "")]
    let cachedMessage = "cached coins"

    var receivedMessages = [Message]()

    func primary() async throws -> [CryptoSphere.DisplayedCoin] {
        receivedMessages.append(.primaryCalled)
        if !internetActivated { throw ListCoinsFallbackSpyError() }
        return coins
    }
    
    func secondary() throws -> ([CryptoSphere.DisplayedCoin], String) {
        receivedMessages.append(.secondaryCalled)
        if !cachePopulated { throw ListCoinsFallbackSpyError() }
        return (coins, cachedMessage)
    }
}
