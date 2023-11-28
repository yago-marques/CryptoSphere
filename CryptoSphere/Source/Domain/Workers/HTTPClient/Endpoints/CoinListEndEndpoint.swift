//
//  CoinListEndEndpoint.swift
//  CryptoSphere
//
//  Created by Yago Marques on 27/11/23.
//

import Foundation

struct CoinListEndEndpoint: EndpointProtocol {
    var urlBase = "https://api.coingecko.com"
    var path = "/api/v3/search/trending"
    var httpMethod: HTTPMethod = .get
    var body = Data()
    var headers: [String : String] = [:]
    var queries: [URLQueryItem] = []
}
