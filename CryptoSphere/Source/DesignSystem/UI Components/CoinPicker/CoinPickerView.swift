//
//  CoinPicker.swift
//  CryptoSphere
//
//  Created by Yago Marques on 29/11/23.
//

import SwiftUI

struct CoinPickerView: View {
    @StateObject var viewModel: CoinPickerViewModel

    var body: some View {
        NavigationStack {
            VStack {
                coinList
                buttonToAdd
            }
            .overlay {
                if viewModel.loading {
                    ProgressView()
                } else if viewModel.coins.isEmpty {
                    Text("No available coin to add")
                }
            }
        }
        .overlay {
            if viewModel.internetError {
                DS.components.internetErrorView(message: "Connection error")
            }
        }
        .background(DS.backgrounds.secondary)
        .task {
            await viewModel.fetchCoins()
        }
    }

    private var coinList: some View {
        List(viewModel.coins) { coin in
            DS.components.coinCard(for: coin)
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .overlay {
                    Circle()
                        .foregroundStyle(viewModel.isSelected(coin.id) ? DS.backgrounds.action : DS.backgrounds.secondary)
                        .frame(width: 25, height: 25)
                        .offset(x: 150, y: -40)
                        .onTapGesture {
                            viewModel.tapGestureHandler(id: coin.id)
                        }
                        .background {
                            Circle()
                                .foregroundStyle(DS.fontColors.secondary)
                                .frame(width: 27, height: 27)
                                .offset(x: 150, y: -40)
                        }
                        .overlay {
                            if viewModel.isSelected(coin.id) {
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
                viewModel.addButtonHandler()
            }
            .disabled(viewModel.selectedCoins.isEmpty)
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
