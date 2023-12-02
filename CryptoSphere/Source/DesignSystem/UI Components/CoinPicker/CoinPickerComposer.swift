//
//  CoinPickerComposer.swift
//  CryptoSphere
//
//  Created by Yago Marques on 29/11/23.
//

import SwiftUI

enum CoinPickerComposer {
    static func make(
        registeredCoins: [String],
        handler: @escaping ([String]) -> Void
    ) -> some View {
        let httpClient = URLSessionHTTPClient(session: URLSession.shared)
        let coinLoader = RemoteCoinLoaderService(httpClient: httpClient)
        let cacheManager = CoinCacheManager(
            coinRepository: CoredataPersistanceManager(),
            cacheVersionRepository: CoredataPersistanceManager()
        )
        let fallback = ListCoinsFallback(coinLoader: coinLoader, cacheManager: cacheManager)
        let viewModel = CoinPickerViewModel(
            fallback: fallback,
            registeredCoins: registeredCoins,
            handler: handler
        )
        let view = CoinPickerView(viewModel: viewModel)

        return view
    }
}
