//
//  CoinPickerViewModel.swift
//  CryptoSphere
//
//  Created by Yago Marques on 02/12/23.
//

import Foundation

final class CoinPickerViewModel: ObservableObject {
    @Published var coins = [DisplayedCoin]()
    @Published var selectedCoins = [String]()
    @Published var loading = false
    @Published var internetError = false
    let handler: ([String]) -> Void
    let registeredCoins: [String]
    let fallback: ListCoinsFallbackProtocol

    init(
        fallback: ListCoinsFallbackProtocol,
        registeredCoins: [String],
        handler: @escaping ([String]) -> Void
    ) {
        self.fallback = fallback
        self.registeredCoins = registeredCoins
        self.handler = handler
    }

    @MainActor
    func fetchCoins() async {
        do {
            loading = true
            coins = try await fallback.primary()
                .filter { !registeredCoins.contains($0.id) }
            loading = false
        } catch {
            loading = false
            internetError = true
        }
    }

    func tapGestureHandler(id: String) {
        isSelected(id) ?
        selectedCoins.removeAll(where: { $0 == id }) :
        selectedCoins.append(id)
    }

    func isSelected(_ coinId: String) -> Bool {
        selectedCoins.contains(coinId)
    }

    func addButtonHandler() {
        handler(selectedCoins)
    }
}
