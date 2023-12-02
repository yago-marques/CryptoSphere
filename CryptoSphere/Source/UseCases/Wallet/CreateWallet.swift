//
//  CreateWallet.swift
//  CryptoSphere
//
//  Created by Yago Marques on 02/12/23.
//

import Foundation

protocol CreateWallet {
    func createWallet(_ wallet: Wallet) async throws
}
