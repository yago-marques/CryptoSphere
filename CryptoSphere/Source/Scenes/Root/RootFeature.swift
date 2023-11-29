import ComposableArchitecture
import Foundation

@Reducer
struct RootFeature {
    struct State: Equatable {
        var selectedTab = Tab.listCoins
        var listCoinsState = ListCoinsFeature.State()
        var walletState = WalletFeature.State()
    }

    enum Tab {
        case listCoins
        case wallet
    }

    enum Action: Equatable {
        case tabSelected(Tab)
        case listCoins(ListCoinsFeature.Action)
        case wallet(WalletFeature.Action)
    }

    let coinLoader: CoinLoader
    let cacheManager: CoinCache

    static let live = Self(
        coinLoader: RemoteCoinLoaderService(
            httpClient: URLSessionHTTPClient(session: URLSession.shared)
        ),

        cacheManager: CoinCacheManager (
            coinRepository: CoredataPersistanceManager(),
            cacheVersionRepository: CoredataPersistanceManager()
        )
    )

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .tabSelected(let tab):
                state.selectedTab = tab
                return .none

            case .listCoins(_):
                return .none

            case .wallet(_):
                return .none
            }

            Scope(
                state: \RootFeature.State.listCoinsState,
                action: /RootFeature.Action.listCoins) {
                    ListCoinsFeature(
                        coinLoader: coinLoader,
                        cacheManager: cacheManager
                    )
                }
        }
    }
}
