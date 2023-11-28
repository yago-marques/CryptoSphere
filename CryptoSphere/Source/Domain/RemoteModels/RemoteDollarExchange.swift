//
//  RemoteDollarExchange.swift
//  CryptoSphere
//
//  Created by Yago Marques on 28/11/23.
//

import Foundation

struct RemoteExchange: Decodable {
    let rates: [String: USDExchange]
}

struct USDExchange: Decodable {
    let value: Decimal
}
