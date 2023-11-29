//
//  CoinPicker.swift
//  CryptoSphere
//
//  Created by Yago Marques on 29/11/23.
//

import SwiftUI

struct CoinPicker: View {
    @State var coins = [DisplayedCoin]()
    let fallback: ListCoinsFallbackProtocol

    var body: some View {
        NavigationStack {
            List(coins) { coin in
                DS.components.coinCard(for: coin)
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .navigationTitle("Trending coins")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.plain)
            .background(DS.backgrounds.secondary)
        }
        .task {
            Task {
                do {
                    coins = try await fallback.primary()
                } catch {
                    print("error")
                }

            }
        }
    }
}
