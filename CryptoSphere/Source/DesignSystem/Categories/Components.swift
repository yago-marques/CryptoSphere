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

    static func coinManageRow(
        coin: String,
        handler: @escaping () -> Void
    ) -> some View {
        CoinManageRow(coin: coin, handler: handler)
    }

    static func walletDetails(_ wallet: DisplayedWallet) -> some View {
        WalletSeeDetail(wallet: wallet)
    }

    static func walletIconPicker(icon: Binding<String>) -> some View {
        WalletIconPicker(selectedAvatar: icon)
    }

    static func iconGallery(selectedIcon: Binding<String>) -> some View {
        IconGallery(avatarToModify: selectedIcon)
    }

    static func walletEditor(
        mode: WalletManagerMode,
        handler: @escaping (Wallet) -> Void
    ) -> some View {
        WalletManagerComposer.make(mode: mode, handler: handler)
    }

    static func textPicker(
        text: Binding<String>, title: String, placeholder: String
    ) -> some View {
        TextPicker(text: text, title: title, placeholder: placeholder)
    }
}
