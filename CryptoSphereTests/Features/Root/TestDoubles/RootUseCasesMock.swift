//
//  RootUseCasesSpy.swift
//  CryptoSphereTests
//
//  Created by Yago Marques on 03/12/23.
//

import Foundation
@testable import CryptoSphere

final class RootUseCasesMock: RootUseCases {
    var firstAccess = false

    func verifyUserFirstAccess() -> Bool {
        !firstAccess
    }
}
