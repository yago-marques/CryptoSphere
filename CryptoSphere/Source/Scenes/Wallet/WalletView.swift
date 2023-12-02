import ComposableArchitecture
import SwiftUI

struct WalletView: View {
    let store: StoreOf<WalletFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                List(viewStore.wallets) { wallet in
                    DS.components.walletCard(
                        for: wallet,
                        handlers: .init(
                            presentEditWalletView: {
                                viewStore.send(.openWalletManagerToEdit(wallet: wallet))
                            },
                            presentCoinPicker: {
                                viewStore.send(.openCoinPicker)
                            }
                        )
                    )
                        .listRowSeparator(.hidden)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                .navigationTitle("Wallet")
                .navigationBarTitleDisplayMode(.inline)
                .listStyle(.plain)
                .background(DS.backgrounds.secondary)
                .toolbar {
                    ToolbarItem {
                        Button{
                            viewStore.send(.openWalletManager)
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(DS.backgrounds.action)
                        }
                        .foregroundStyle(DS.backgrounds.action)
                    }
                }
            }
            .sheet(
                isPresented: viewStore.binding(
                    get: { $0.shouldPresentCoinPicker },
                    send: .openCoinPicker
                ),
                onDismiss: {
                    viewStore.send(.closePicker)
                }
            ) {
                DS.components.coinPicker()
            }
            .sheet(
                isPresented: viewStore.binding(
                    get: { $0.shouldPresentWalletManager },
                    send: .openWalletManager
                ),
                onDismiss: {
                    viewStore.send(.closeWalletmanager)
                }
            ) {
                WalletManagerComposer
                    .make(mode: .create) { wallet in
                        viewStore.send(.createNewWallet(wallet))
                }
            }
            .sheet(
                isPresented: viewStore.binding(
                    get: { $0.shouldPresentWalletManagerToEdit },
                    send: .openWalletManagerToEdit(wallet: viewStore.walletToEdit)
                ),
                onDismiss: {
                    viewStore.send(.closeWalletmanagerToEdit)
                }
            ) {
                WalletManagerComposer
                    .make(
                        mode: .editable(
                            wallet: viewStore.walletToEdit
                        )
                    ) { wallet in
                        viewStore.send(.updateWallet(wallet))
                    }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

#Preview {
    WalletComposer.make()
}
