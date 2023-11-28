//
//  HTTPClientProtocol.swift
//  CryptoSphere
//
//  Created by Yago Marques on 27/11/23.
//

import Foundation

protocol HTTPClient {
    func request(endpoint: EndpointProtocol) async throws -> Data?
}
