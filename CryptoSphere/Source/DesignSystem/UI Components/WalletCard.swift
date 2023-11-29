//
//  WalletCard.swift
//  CryptoSphere
//
//  Created by Yago Marques on 29/11/23.
//

import SwiftUI

struct WalletCard: View {
    let wallet: DisplayedWallet

    var body: some View {
        HStack {
            HStack {
                Image(uiImage: .init(data: wallet.image) ?? .init(named: "defaultCoin")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)

                VStack(alignment: .leading) {
                    Text(wallet.name)
                        .bold()
                        .font(.title2)
                        .foregroundStyle(DS.fontColors.primary)
                    Text("\(wallet.coins.count) coins")
                        .foregroundStyle(DS.fontColors.secondary)
                }
                .padding(.leading, 5)
                Spacer()
                Button {
                    print("oi")
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(DS.backgrounds.action)
                        .frame(width: 30)
                }
                .padding(.trailing)

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
