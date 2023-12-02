//
//  WalletManagerViewModel.swift
//  CryptoSphere
//
//  Created by Yago Marques on 30/11/23.
//

import SwiftUI

final class WalletManagerViewModel: ObservableObject {
    @Published var walletIcon = "defaultCoin"
    @Published var walletName = String()
    let mode: WalletManagerMode
    var buttonActionLabel: String {
        return mode == .create ? "Create wallet" : "Update wallet"
    }
    let handler: (Wallet) -> Void

    init(
        mode: WalletManagerMode,
        handler: @escaping (Wallet) -> Void
    ) {
        self.mode = mode
        self.handler = handler

        populateIfNeeded()
    }

    func isDisabledButton() -> Bool {
        switch mode {
        case .editable(let wallet):
            return !isWalletUpdated(wallet)
        case .create:
            return walletName.isEmpty
        }
    }

    func populateIfNeeded() {
        if case let .editable(wallet) = mode {
            walletIcon = wallet.image
            walletName = wallet.name
        }
    }

    func isWalletUpdated(_ wallet: DisplayedWallet) -> Bool {
        if
            wallet.image == walletIcon,
            wallet.name == walletName
        {
            return false
        } else {
            return true
        }
    }

    func buttonHandler() {
        let wallet: Wallet

        switch mode {
        case .editable(let oldWallet):
            wallet = .init(
                id: oldWallet.id,
                name: walletName,
                image: walletIcon,
                coins: oldWallet.coins
            )
        case .create:
            wallet = .init(
                id: UUID().uuidString,
                name: walletName,
                image: walletIcon,
                coins: []
            )
        }

        handler(wallet)
    }

}
