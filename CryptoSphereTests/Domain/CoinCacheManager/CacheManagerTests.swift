//
//  CacheManagerTests.swift
//  CryptoSphereTests
//
//  Created by Yago Marques on 03/12/23.
//

import Foundation
@testable import CryptoSphere
import XCTest

typealias CacheManagerSUT = (
    sut: CoinCacheManager,
    doubles: (
        coinRepository: CoinRepositoryMock,
        cacheVersionRepository: CacheVersionRepositorySpy
    )
)

final class CacheManagerTests: XCTestCase {
    func test_TryFetchFromCache_WhenCacheIsEmpty_ShouldThrowError() {
        let (sut, _) = makeSUT()

        XCTAssertThrowsError(try sut.tryFetchFromCache())
    }

    func test_TryFetchFromCache_WhenCacheIsNotEmpty_ShouldReturnCachedCoins() throws {
        let (sut, (coinRepository, _)) = makeSUT()
        coinRepository.populate()

        let coins = try sut.tryFetchFromCache()

        XCTAssertEqual(coins, coinRepository.coins)
    }

    func test_LastCacheMessage_WhenCanAccessLastCacheVersion_ShouldReturnValidMessage() throws {
        let (sut, _) = makeSUT()

        let message = try sut.lastCacheMessage()

        XCTAssertNotEqual(message, "invalid cache")
    }

    func test_LastCacheMessage_WhenCanNotAccessLastCacheVersion_ShouldReturnInvalidMessage() throws {
        let (sut, (_, cacheVersionRepository)) = makeSUT()
        cacheVersionRepository.lastDate = nil

        let message = try sut.lastCacheMessage()

        XCTAssertEqual(message, "invalid cache")
    }

    func test_SaveInCacheIfNeeded_WhenLastCacheVersionIsInvalid_ShouldRegisterCache() throws {
        let (sut, (coinRepository, cacheVersionRepository)) = makeSUT()
        cacheVersionRepository.lastDate = nil
        let coinsToAdd: [DisplayedCoin] = [.init(id: "", name: "", marketRank: 1, image: Data(), dollarPrice: "")]

        try sut.saveInCacheIfNeeded(coinsToAdd)

        XCTAssertEqual(coinRepository.receivedMessages, [.saveCoinsCalled])
        XCTAssertEqual(cacheVersionRepository.receivedMessages, [.getLastDateCalled, .registerUpdateCalled])
    }

    func test_SaveInCacheIfNeeded_WhenLastCacheVersionIsValid_WhenDateDiffIsLessThanOneHour_ShouldNotReplace() throws {
        let (sut, (coinRepository, cacheVersionRepository)) = makeSUT()
        cacheVersionRepository.lastDate = Date()
        let coinsToAdd: [DisplayedCoin] = [.init(id: "", name: "", marketRank: 1, image: Data(), dollarPrice: "")]

        try sut.saveInCacheIfNeeded(coinsToAdd)

        XCTAssertEqual(coinRepository.receivedMessages, [])
        XCTAssertEqual(cacheVersionRepository.receivedMessages, [.getLastDateCalled])
    }

    func test_SaveInCacheIfNeeded_WhenLastCacheVersionIsValid_WhenDateDiffIsMoreThanOneHour_ShouldReplace() throws {
        let (sut, (coinRepository, cacheVersionRepository)) = makeSUT()
        cacheVersionRepository.lastDate = Date.oneHourEarlier()
        let coinsToAdd: [DisplayedCoin] = [.init(id: "", name: "", marketRank: 1, image: Data(), dollarPrice: "")]

        try sut.saveInCacheIfNeeded(coinsToAdd)

        XCTAssertEqual(coinRepository.receivedMessages, [.replaceCoinsCalled])
        XCTAssertEqual(cacheVersionRepository.receivedMessages, [.getLastDateCalled, .registerUpdateCalled])
    }

    func test_SaveInCacheIfNeeded_WhenLastCacheVersionIsValid_WhenIsDifferentDay_ShouldReplace() throws {
        let (sut, (coinRepository, cacheVersionRepository)) = makeSUT()
        cacheVersionRepository.lastDate = Date.distantPast
        let coinsToAdd: [DisplayedCoin] = [.init(id: "", name: "", marketRank: 1, image: Data(), dollarPrice: "")]

        try sut.saveInCacheIfNeeded(coinsToAdd)

        XCTAssertEqual(coinRepository.receivedMessages, [.replaceCoinsCalled])
        XCTAssertEqual(cacheVersionRepository.receivedMessages, [.getLastDateCalled, .registerUpdateCalled])
    }
}

private extension CacheManagerTests {
    func makeSUT() -> CacheManagerSUT {
        let coinRepository = CoinRepositoryMock()
        let cacheVersion = CacheVersionRepositorySpy()
        let sut = CoinCacheManager(
            coinRepository: coinRepository,
            cacheVersionRepository: cacheVersion
        )

        return (sut, (coinRepository, cacheVersion))
    }
}
