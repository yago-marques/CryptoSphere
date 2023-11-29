import ComposableArchitecture
import SwiftUI

struct WalletView: View {
    let store: StoreOf<WalletFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                Text(viewStore.initialMessage)
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}
