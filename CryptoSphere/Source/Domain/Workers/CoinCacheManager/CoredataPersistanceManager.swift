//
//  CoredataPersistanceManager.swift
//  CryptoSphere
//
//  Created by Yago Marques on 28/11/23.
//

import Foundation
import CoreData

struct CoredataPersistanceManager {
    let persistentContainer: NSPersistentContainer

    init(
        persistentContainer: NSPersistentContainer = PersistenceController.shared.container
    ) {
        self.persistentContainer = persistentContainer
    }
}

extension CoredataPersistanceManager: CoinRepository {
    func coinsIsEmpty() throws -> Bool {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CoinEntity>(entityName: "CoinEntity")
        let coredataEntities = try context.fetch(fetchRequest)

        return coredataEntities.isEmpty
    }

    func saveCoins(_ coins: [DisplayedCoin]) throws {
        let context = persistentContainer.viewContext
        let _ = coins.map { CoinMapper.toCached(from: $0, context: context) }

        try context.save()
    }

    func replaceCoins(for newCoins: [DisplayedCoin]) throws {
        try deleteAllCoins()
        try saveCoins(newCoins)
    }

    func readCoins() throws -> [DisplayedCoin] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CoinEntity>(entityName: "CoinEntity")
        let coredataEntities = try context.fetch(fetchRequest)
        let coins = coredataEntities.map { CoinMapper.toDisplayed(from: $0) }

        return coins
    }

    private func deleteAllCoins() throws {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CoinEntity>(entityName: "CoinEntity")
        let coredataEntities = try context.fetch(fetchRequest)
        for entity in coredataEntities {
            context.delete(entity)
        }

        try context.save()
    }
}

extension CoredataPersistanceManager: CacheVersionRepository {
    func getLastDate() throws -> Date? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<LastCoinCache>(entityName: "LastCoinCache")
        let coredataEntities = try context.fetch(fetchRequest)
        guard let lastDate = coredataEntities.first?.date else { return nil }

        return lastDate
    }
    
    func registerUpdate() throws {
        let context = persistentContainer.viewContext

        if try getLastDate() != nil {
            let fetchRequest = NSFetchRequest<LastCoinCache>(entityName: "LastCoinCache")
            let coredataEntities = try context.fetch(fetchRequest)
            guard let entity = coredataEntities.first else { return }
            entity.date = Date()
        } else {
            let entity = LastCoinCache(context: context)
            entity.date = Date()
        }

        try context.save()
    }
}
