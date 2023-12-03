import ComposableArchitecture
import SwiftUI
import Foundation

typealias WalletFeatureUseCases = FetchWallets & DeleteWallet & UpdateWallet & CreateWallet

@Reducer
struct WalletFeature {
    let useCases: WalletFeatureUseCases

    struct State: Equatable {
        var wallets = [DisplayedWallet]()
        var loading = false
        var shouldPresentCoinPicker = false
        var shouldPresentWalletManager = false
        var shouldPresentWalletManagerToEdit = false
        var shouldPresentWalletDetail = false
        var walletToEdit = DisplayedWallet(id: "", name: "", image: "", coins: [])
        var walletToSee = DisplayedWallet(id: "", name: "", image: "", coins: [])
        var internetError = false
    }

    enum Action: Equatable {
        case onAppear
        case onAppearResponse(wallets: [DisplayedWallet])
        case updateTable
        case openCoinPicker(DisplayedWallet)
        case closePicker
        case openWalletManager
        case closeWalletmanager
        case openWalletManagerToEdit(wallet: DisplayedWallet)
        case closeWalletmanagerToEdit
        case createNewWallet(Wallet)
        case updateWallet(Wallet)
        case registerNewCoins([String], DisplayedWallet)
        case removeWallet(id: String)
        case openWalletDetail(DisplayedWallet)
        case closeWalletDetail
        case registerInternetError
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if state.wallets.isEmpty {
                    state.loading = true
                    return .run { send in
                        await send(.updateTable)
                    }
                } else {
                    return .none
                }

            case .updateTable:
                state.loading = true
                return .run { send in
                    do {
                        try await InternetVerifier.shared.tryConnection()
                        let wallets = try await useCases.fetchWallets()
                        let displayedWallets = wallets.map { WalletMapper.toDisplayed(from: $0) }

                        await send(.onAppearResponse(wallets: displayedWallets))
                    } catch {
                        await send(.registerInternetError)
                    }
                }

            case .onAppearResponse(wallets: let wallets):
                state.loading = false
                state.wallets = wallets
                return .none

            case .openCoinPicker(let wallet):
                state.walletToEdit = wallet
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
                    do {
                        try await InternetVerifier.shared.tryConnection()
                        try await useCases.createWallet(wallet)

                        await send(.closeWalletmanager)
                        await send(.updateTable)
                    } catch {
                        await send(.registerInternetError)
                    }

                }

            case .updateWallet(let wallet):
                return .run { send in
                    do {
                        try await InternetVerifier.shared.tryConnection()
                        try await useCases.updateWallet(wallet)

                        await send(.closeWalletmanagerToEdit)
                        await send(.updateTable)
                    } catch {
                        await send(.registerInternetError)
                    }

                }
            case .registerNewCoins(let coins, let wallet):
                return .run { send in
                    do {
                        try await InternetVerifier.shared.tryConnection()
                        var walletToModify = WalletMapper.toBusiness(from: wallet)
                        walletToModify.coins += coins
                        try await useCases.updateWallet(walletToModify)

                        await send(.closePicker)
                        await send(.updateTable)
                    } catch {
                        await send(.registerInternetError)
                    }

                }

            case .removeWallet(let id):
                return .run { send in
                    do {
                        try await InternetVerifier.shared.tryConnection()
                        try await useCases.deleteWallet(id: id)

                        await send(.updateTable)
                    } catch {
                        await send(.registerInternetError)
                    }

                }
                
            case .openWalletDetail(let wallet):
                state.walletToSee = wallet
                state.shouldPresentWalletDetail = true
                return .none

            case .closeWalletDetail:
                state.shouldPresentWalletDetail = false
                return .none

            case .registerInternetError:
                state.loading = false
                state.internetError = true
                return .none
            }
        }
    }
}
