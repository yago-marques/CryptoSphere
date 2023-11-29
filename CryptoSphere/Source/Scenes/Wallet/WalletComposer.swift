import SwiftUI
import ComposableArchitecture

enum WalletComposer {
    static func make() -> some View {
        let store = Store(initialState: WalletFeature.State()) {
            WalletFeature()
        }
        let view = WalletView(store: store)

        return view
    }
}
