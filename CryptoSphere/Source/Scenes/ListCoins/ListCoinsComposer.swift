//
//  ListCoinsComposer.swift
//  CryptoSphere
//
//  Created by Yago Marques on 28/11/23.
//

import ComposableArchitecture
import SwiftUI

enum ListCoinsComposer {
    static func make() -> some View {
        let httpClient = URLSessionHTTPClient(session: URLSession.shared)
        let coinLoader = RemoteCoinLoaderService(httpClient: httpClient)
        let cacheManager = CoinCacheManager(
            coinRepository: CoredataPersistanceManager(),
            cacheVersionRepository: CoredataPersistanceManager()
        )
        let fallback = ListCoinsFallback(coinLoader: coinLoader, cacheManager: cacheManager)

        let store = Store(initialState: ListCoinsFeature.State()) {
            ListCoinsFeature(fallback: fallback)
        }
        let view = ListCoinsView(store: store)

        return view
    }
}
