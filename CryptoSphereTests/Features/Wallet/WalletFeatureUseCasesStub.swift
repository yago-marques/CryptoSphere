//
//  WalletFeatureUsecasesMock.swift
//  CryptoSphereTests
//
//  Created by Yago Marques on 03/12/23.
//

import Foundation
@testable import CryptoSphere

final class WalletFeatureUseCasesStub: WalletFeatureUseCases {

    var wallets = [Wallet]()

    func createWallet(_ wallet: CryptoSphere.Wallet) async throws {
        wallets.append(wallet)
    }
    
    func deleteWallet(id: String) async throws {
        wallets.removeAll(where: { $0.id == id })
    }
    
    func fetchWallets() async throws -> [CryptoSphere.Wallet] {
        wallets
    }
    
    func updateWallet(_ wallet: CryptoSphere.Wallet) async throws {
        guard let index = wallets
            .firstIndex(where: { $0.id == wallet.id }) else { return }
        wallets[index] = wallet
    }
}
