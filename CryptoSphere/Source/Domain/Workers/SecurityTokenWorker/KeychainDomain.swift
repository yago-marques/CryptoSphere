//
//  KeychainDomain.swift
//  CryptoSphere
//
//  Created by Yago Marques on 30/11/23.
//

import Foundation

enum KeychainError: Error {
    case duplicateItem
    case unexpectedStatus(OSStatus)
    case itemNotFound
    case invalidItemFormat
}

protocol KeychainRepository {
    func create(token: Data, service: String, account: String) throws
    func read(service: String, account: String) throws -> String
}

struct KeychainDomain: KeychainRepository {
    func create(token: Data, service: String, account: String) throws {
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            kSecValueData as String: token as AnyObject,
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        if status == errSecDuplicateItem {
            throw KeychainError.duplicateItem
        }

        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }

    func read(service: String, account: String) throws -> String {
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: kCFBooleanTrue
        ]

        var itemCopy: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &itemCopy)

        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }

        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }

        guard
            let data = itemCopy as? Data,
            let token = String(data: data, encoding: .utf8)
        else {
            throw KeychainError.invalidItemFormat
        }

        return token
    }
}
