//
//  WalletManagerComposer.swift
//  CryptoSphere
//
//  Created by Yago Marques on 29/11/23.
//

import SwiftUI

enum WalletManagerComposer {
    static func make(
        mode: WalletManagerMode,
        handler: @escaping (Wallet) -> Void
    ) -> some View {
        let viewModel = WalletManagerViewModel(mode: mode, handler: handler)
        let view = WalletManagerView(viewModel: viewModel)

        return view
    }
}
