//
//  CacheVersionRepository.swift
//  CryptoSphere
//
//  Created by Yago Marques on 28/11/23.
//

import Foundation

protocol CacheVersionRepository {
    func getLastDate() throws -> Date?
    func registerUpdate() throws
}
