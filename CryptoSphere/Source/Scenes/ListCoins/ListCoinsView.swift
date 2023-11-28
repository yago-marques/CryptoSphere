import ComposableArchitecture
import SwiftUI

struct CoinCard: View {
    let coin: DisplayedCoin
    @State var image = Image.defaultCoinImage

    init(for coin: DisplayedCoin) {
        self.coin = coin
    }

    var body: some View {
        HStack {
            image
        }
        .task {
            await image.download(from: coin.imageUrl)
        }
    }
}

struct ListCoinsView: View {
    let store: StoreOf<ListCoinsFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                List(viewStore.coins) { coin in
                    CoinCard(for: coin)
                        .listRowSeparator(.hidden)
                }
                .navigationTitle("Coins")
                .listStyle(.plain)
                .background(DS.backgrounds.secondary)
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
                    )
            )
        }
    )
}
