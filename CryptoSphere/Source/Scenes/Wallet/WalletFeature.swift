import ComposableArchitecture
import SwiftUI
import Foundation

typealias WalletFeatureUseCases = FetchWallets & DeleteWallet & UpdateWallet & CreateWallet

@Reducer
struct WalletFeature {
    let useCases: WalletFeatureUseCases

    struct State: Equatable {
        var wallets = [DisplayedWallet]()
        var shouldPresentCoinPicker = false
        var shouldPresentWalletManager = false
        var shouldPresentWalletManagerToEdit = false
        var walletToEdit = DisplayedWallet(id: "", name: "", image: "", coins: [])
    }

    enum Action: Equatable {
        case onAppear
        case onAppearResponse(wallets: [DisplayedWallet])
        case updateTable
        case openCoinPicker
        case closePicker
        case openWalletManager
        case closeWalletmanager
        case openWalletManagerToEdit(wallet: DisplayedWallet)
        case closeWalletmanagerToEdit
        case createNewWallet(Wallet)
        case updateWallet(Wallet)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if state.wallets.isEmpty {
                    return .run { send in
                        await send(.updateTable)
                    }
                } else {
                    return .none
                }

            case .updateTable:
                return .run { send in
                    let wallets = try await useCases.fetchWallets()
                    let displayedWallets = wallets.map { WalletMapper.toDisplayed(from: $0) }

                    await send(.onAppearResponse(wallets: displayedWallets))
                }

            case .onAppearResponse(wallets: let wallets):
                state.wallets = wallets
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

            case .createNewWallet(let wallet):
                return .run { send in
                    try await useCases.createWallet(wallet)

                    await send(.closeWalletmanager)
                    await send(.updateTable)
                }

            case .updateWallet(let wallet):
                return .run { send in
                    try await useCases.updateWallet(wallet)

                    await send(.closeWalletmanagerToEdit)
                    await send(.updateTable)
                }
            }
        }
    }
}
