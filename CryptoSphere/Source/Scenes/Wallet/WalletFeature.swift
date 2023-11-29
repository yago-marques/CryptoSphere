import ComposableArchitecture
import SwiftUI
import Foundation

@Reducer
struct WalletFeature {
    struct State: Equatable {
        var wallets = [DisplayedWallet]()
    }

    enum Action: Equatable {
        case onAppear
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.wallets = [.init(id: "oi", name: "My Wallet", image: Image.defaultCoinImageData, coins: []), .init(id: "oi", name: "My Wallet", image: Image.defaultCoinImageData, coins: [])]
                return .none
            }
        }
    }
}

