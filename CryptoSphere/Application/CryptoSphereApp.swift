//
//  CryptoSphereApp.swift
//  CryptoSphere
//
//  Created by Yago Marques on 27/11/23.
//

import SwiftUI
import ComposableArchitecture
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct CryptoSphereApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            RootComposer.make()
        }
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
