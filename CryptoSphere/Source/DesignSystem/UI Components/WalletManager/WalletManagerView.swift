//
//  WalletManager.swift
//  CryptoSphere
//
//  Created by Yago Marques on 29/11/23.
//

import SwiftUI

enum WalletManagerMode: Equatable {
    case editable(wallet: DisplayedWallet)
    case create
}

struct WalletManagerView: View {
    @StateObject var viewModel: WalletManagerViewModel

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    DS.components.walletIconPicker(icon: $viewModel.walletIcon)
                        .padding(.top, 20)

                    DS.components.textPicker(text: $viewModel.walletName, title: "Wallet name:", placeholder: "Write wallet name")
                        .padding(.top, 30)

                    if viewModel.mode != .create {
                        ForEach(viewModel.walletCoins, id: \.self) { coin in
                            CoinManageRow(coin: coin, handler: {
                                viewModel
                                    .walletCoins
                                    .removeAll(where: { $0 == coin })
                            })
                        }
                    }
                }
                .navigationTitle(viewModel.buttonActionLabel)
                .navigationBarTitleDisplayMode(.inline)
                .frame(width: UIScreen.main.bounds.width)
                .background(DS.backgrounds.secondary)

                VStack {
                    Spacer()
                    Button(viewModel.buttonActionLabel) {
                        viewModel.buttonHandler()
                    }
                    .disabled(viewModel.isDisabledButton())
                    .frame(
                        width: UIScreen.main.bounds.width * 0.9,
                        height: 50
                    )
                    .bold()
                    .background(DS.backgrounds.action)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    Spacer()
                }
                .frame(
                    width: UIScreen.main.bounds.width,
                    height: 70
                )
                .background(DS.backgrounds.primary)
            }
        }

    }
}
