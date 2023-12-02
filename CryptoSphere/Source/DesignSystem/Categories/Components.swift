//
//  Components.swift
//  CryptoSphere
//
//  Created by Yago Marques on 28/11/23.
//

import SwiftUI

struct Components {
    static func internetErrorView(message: String) -> some View {
        InternetErrorView(message: message)
    }

    static func coinCard(for coin: DisplayedCoin) -> some View {
        CoinCard(for: coin)
    }

    static func walletCard(
        for wallet: DisplayedWallet,
        handlers: WalletCardHandlers
    ) -> some View {
        WalletCard(
            wallet: wallet,
            handlers: handlers
        )
    }

    static func coinPicker(
        registeredCoins: [String],
        handler: @escaping ([String]) -> Void
    ) -> some View {
        CoinPickerComposer.make(registeredCoins: registeredCoins, handler: handler)
    }
}
