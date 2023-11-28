//
//  CryptoSphereApp.swift
//  CryptoSphere
//
//  Created by Yago Marques on 27/11/23.
//

import SwiftUI

@main
struct CryptoSphereApp: App {
    var body: some Scene {
        WindowGroup {
            ListCoinsView(
                store: .init( initialState: ListCoinsFeature.State()) {
                    ListCoinsFeature(
                        coinLoader:
                            RemoteCoinLoaderService(
                                httpClient: URLSessionHTTPClient(session: URLSession.shared)
                            )
                    )
                }
            )
        }
    }
}
