//
//  CoinPicker.swift
//  CryptoSphere
//
//  Created by Yago Marques on 29/11/23.
//

import SwiftUI

struct CoinPicker: View {
    @State var coins = [DisplayedCoin]()
    @State var selectedCoins = [String]()
    @State var loading = false
    let fallback: ListCoinsFallbackProtocol

    var body: some View {
        NavigationStack {
            VStack {
                coinList
                buttonToAdd
            }
            .overlay {
                if loading {
                    ProgressView()
                }
            }
        }
        .background(DS.backgrounds.secondary)
        .task {
            Task {
                do {
                    loading = true
                    coins = try await fallback.primary()
                    loading = false
                } catch {
                    loading = false
                    print("error")
                }

            }
        }
    }

    private var coinList: some View {
        List(coins) { coin in
            DS.components.coinCard(for: coin)
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .overlay {
                    Circle()
                        .foregroundStyle(isSelected(coin.id) ? DS.backgrounds.action : DS.backgrounds.secondary)
                        .frame(width: 25, height: 25)
                        .offset(x: 150, y: -40)
                        .onTapGesture {
                            isSelected(coin.id) ?
                            selectedCoins.removeAll(where: { $0 == coin.id }) :
                            selectedCoins.append(coin.id)
                        }
                        .background {
                            Circle()
                                .foregroundStyle(DS.fontColors.secondary)
                                .frame(width: 27, height: 27)
                                .offset(x: 150, y: -40)
                        }
                        .overlay {
                            if isSelected(coin.id) {
                                Image(systemName: "checkmark")
                                    .offset(x: 150, y: -40)
                            }
                        }
                }
        }
        .navigationTitle("Choose coins")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.plain)
        .background(DS.backgrounds.secondary)
    }

    private var buttonToAdd: some View {
        VStack {
            Spacer()
            Button("Add to wallet") {
                print("oi")
            }
            .disabled(selectedCoins.isEmpty)
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

    func isSelected(_ coinId: String) -> Bool {
        selectedCoins.contains(coinId)
    }
}
