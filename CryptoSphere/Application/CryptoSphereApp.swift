//
//  CryptoSphereApp.swift
//  CryptoSphere
//
//  Created by Yago Marques on 27/11/23.
//

import SwiftUI

@main
struct CryptoSphereApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ListCoinsComposer.make()
        }
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
