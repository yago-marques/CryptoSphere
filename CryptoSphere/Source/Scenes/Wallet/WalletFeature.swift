import ComposableArchitecture
import SwiftUI
import Foundation

@Reducer
struct WalletFeature {
    struct State: Equatable {
        var wallets = [DisplayedWallet]()
        var shouldPresentCoinPicker = false
        var shouldPresentWalletManager = false
        var shouldPresentWalletManagerToEdit = false
        var walletToEdit = DisplayedWallet(id: "", name: "", image: "", coins: [])
    }

    enum Action: Equatable {
        case onAppear
        case openCoinPicker
        case closePicker
        case openWalletManager
        case closeWalletmanager
        case openWalletManagerToEdit(wallet: DisplayedWallet)
        case closeWalletmanagerToEdit
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.wallets = [.init(id: "oi", name: "My Wallet", image: "w 1", coins: []), .init(id: "oit", name: "My Wallet", image: "w 2", coins: [])]
                return .none

            case .openCoinPicker:
                state.shouldPresentCoinPicker = true
                return .none

            case .closePicker:
                state.shouldPresentCoinPicker = false
                return .none

            case .openWalletManager:
                state.shouldPresentWalletManager = true
                return .none

            case .closeWalletmanager:
                state.shouldPresentWalletManager = false
                return .none

            case .openWalletManagerToEdit(let wallet):
                state.walletToEdit = wallet
                state.shouldPresentWalletManagerToEdit = true
                return .none

            case .closeWalletmanagerToEdit:
                state.shouldPresentWalletManagerToEdit = false
                return .none
            }
        }
    }
}

