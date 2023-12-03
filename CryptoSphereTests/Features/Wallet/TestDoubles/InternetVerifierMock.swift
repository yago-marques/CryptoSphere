//
//  InternetVerifierMock.swift
//  CryptoSphereTests
//
//  Created by Yago Marques on 03/12/23.
//

import Foundation
@testable import CryptoSphere

struct InternetVerifierMockError: Error {}

final class InternetVerifierMock: VerifyConnection {
    var internetActivated = true

    func verifyConnection() async throws {
        if !internetActivated {
            throw InternetVerifierMockError()
        }
    }
}
