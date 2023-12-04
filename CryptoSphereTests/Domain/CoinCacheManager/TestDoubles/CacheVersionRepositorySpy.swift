//
//  CacheVersionRepositoryMock.swift
//  CryptoSphereTests
//
//  Created by Yago Marques on 03/12/23.
//

@testable import CryptoSphere
import Foundation

final class CacheVersionRepositorySpy: CacheVersionRepository {
    enum Message: Equatable {
        case getLastDateCalled
        case registerUpdateCalled
    }

    var lastDate: Date? = Date()

    var receivedMessages = [Message]()

    func getLastDate() throws -> Date? {
        receivedMessages.append(.getLastDateCalled)
        return lastDate
    }
    
    func registerUpdate() throws {
        receivedMessages.append(.registerUpdateCalled)
    }
}
