//
//  CoinPickerComposer.swift
//  CryptoSphere
//
//  Created by Yago Marques on 29/11/23.
//

import SwiftUI

enum CoinPickerComposer {
    static func make() -> some View {
        let httpClient = URLSessionHTTPClient(session: URLSession.shared)
        let coinLoader = RemoteCoinLoaderService(httpClient: httpClient)
        let cacheManager = CoinCacheManager(
            coinRepository: CoredataPersistanceManager(),
            cacheVersionRepository: CoredataPersistanceManager()
        )
        let fallback = ListCoinsFallback(coinLoader: coinLoader, cacheManager: cacheManager)
        let view = CoinPicker(fallback: fallback)

        return view
    }
}
