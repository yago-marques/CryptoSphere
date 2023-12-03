//
//  CoinManageRow.swift
//  CryptoSphere
//
//  Created by Yago Marques on 02/12/23.
//

import SwiftUI

struct CoinManageRow: View {
    let coin: String
    let handler: () -> Void

    var body: some View {
        HStack {
            Text(coin)
            Spacer()
            Image(systemName: "trash")
                .foregroundStyle(.red)
                .onTapGesture {
                    handler()
                }
        }
        .frame(width: UIScreen.main.bounds.width * 0.85)
        .padding()
    }
}
