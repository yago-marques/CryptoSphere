//
//  UpdateWallet.swift
//  CryptoSphere
//
//  Created by Yago Marques on 02/12/23.
//

import Foundation

protocol UpdateWallet {
    func updateWallet(_ wallet: Wallet) async throws
}
