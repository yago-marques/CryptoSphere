import ComposableArchitecture
import SwiftUI

struct ListCoinsView: View {
    let store: StoreOf<ListCoinsFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                List(viewStore.coins) { coin in
                    CoinCard(for: coin)
                        .listRowSeparator(.hidden)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                .navigationTitle("Coins")
                .navigationBarTitleDisplayMode(.inline)
                .listStyle(.plain)
                .background(DS.backgrounds.primary)
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

#Preview {
    ListCoinsView(
        store: .init( initialState: ListCoinsFeature.State()) {
            ListCoinsFeature(
                coinLoader:
                    RemoteCoinLoaderService(
                        httpClient: URLSessionHTTPClient(session: URLSession.shared)
                    ), cacheManager: CoinCacheManager()
            )
        }
    )
}
