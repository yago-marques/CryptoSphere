//
//  FetchWallest.swift
//  CryptoSphere
//
//  Created by Yago Marques on 02/12/23.
//

import Foundation

protocol FetchWallets {
    func fetchWallets() async throws -> [Wallet]
}
