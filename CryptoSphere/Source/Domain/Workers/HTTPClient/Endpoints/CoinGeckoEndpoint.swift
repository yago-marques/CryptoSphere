//
//  DolarExchangeRateEndpoint.swift
//  CryptoSphere
//
//  Created by Yago Marques on 28/11/23.
//

import Foundation

struct CoinGeckoEndpoint: EndpointProtocol {
    var urlBase = "https://api.coingecko.com"
    var path: String
    var httpMethod: HTTPMethod = .get
    var body = Data()
    var headers: [String : String] = [:]
    var queries: [URLQueryItem] = []
}
