//
//  DisplayedWallet.swift
//  CryptoSphere
//
//  Created by Yago Marques on 29/11/23.
//

import Foundation

struct DisplayedWallet: Equatable, Identifiable {
    let id: String
    let name: String
    let image: Data
    let coins: [String]
}
