import ComposableArchitecture
import SwiftUI

struct WalletView: View {
    let store: StoreOf<WalletFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                List(viewStore.wallets) { wallet in
                    DS.components.walletCard(for: wallet) {
                        viewStore.send(.openCoinPicker)
                    }
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
                            print("oi")
                        } label: {
                            Text("Create new")
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
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

#Preview {
    WalletComposer.make()
}
