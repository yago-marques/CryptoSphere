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
                    WalletIconPicker(selectedAvatar: $viewModel.walletIcon)
                        .padding(.top, 20)

                    TextPicker(text: $viewModel.walletName, title: "Wallet name:", placeholder: "Write wallet name")
                        .padding(.top, 30)
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
