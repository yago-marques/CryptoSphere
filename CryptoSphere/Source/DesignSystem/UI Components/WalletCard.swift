//
//  WalletCard.swift
//  CryptoSphere
//
//  Created by Yago Marques on 29/11/23.
//

import SwiftUI

struct WalletCardHandlers {
    let pushSeeDetailsView: () -> Void
    let presentEditWalletView: () -> Void
    let presentCoinPicker: () -> Void
    let deleteWallet: () -> Void
}

struct WalletCard: View {
    let wallet: DisplayedWallet
    let handlers: WalletCardHandlers

    var body: some View {
        HStack {
            HStack {
                Image(wallet.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)

                VStack(alignment: .leading) {
                    Text(wallet.name)
                        .bold()
                        .font(.title2)
                        .foregroundStyle(DS.fontColors.primary)
                    Text("\(wallet.coins.count) \(wallet.coins.count == 1 ? "Coin" : "Coins")")
                        .foregroundStyle(DS.fontColors.secondary)
                }
                .padding(.leading, 5)
                Spacer()
                Menu {
                    Button(
                        "See Details",
                        action: handlers.pushSeeDetailsView
                    )
                    Button(
                        "Edit wallet",
                        action: handlers.presentEditWalletView
                    )
                    Button(
                        "Add coins to wallet",
                        action: handlers.presentCoinPicker
                    )
                    Button(
                        "Remove wallet",
                        role: .destructive,
                        action: handlers.deleteWallet
                    )
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(DS.backgrounds.action)
                        .frame(width: 25)
                        .padding(.trailing)
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.9)
            .background(DS.backgrounds.tertiary)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(DS.fontColors.primary)
            }
        }
        .padding(10)
        .frame(width: UIScreen.main.bounds.width)
        .background(DS.backgrounds.secondary)
    }
}
