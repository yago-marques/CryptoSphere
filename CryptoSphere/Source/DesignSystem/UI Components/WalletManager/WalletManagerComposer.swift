//
//  WalletManagerComposer.swift
//  CryptoSphere
//
//  Created by Yago Marques on 29/11/23.
//

import SwiftUI

enum WalletManagerComposer {
    static func make(mode: WalletManagerMode) -> some View {
        let viewModel = WalletManagerViewModel(mode: mode)
        let view = WalletManagerView(viewModel: viewModel)

        return view
    }
}
