//
//  RemoteWallet.swift
//  CryptoSphere
//
//  Created by Yago Marques on 02/12/23.
//

import Foundation

struct RemoteWallet: Codable {
    let id: String
    let name: String
    let image: String
    let coins: [String]
}
