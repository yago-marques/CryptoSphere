import ComposableArchitecture

struct DisplayedCoin: Equatable, Identifiable {
    let id: String
    let name: String
    let marketRank: Int
    let imageUrl: String
    let dollarPrice: String
}

@Reducer
struct ListCoinsFeature {
    let coinLoader: CoinLoader
    let cacheManager: CoinCache

    struct State: Equatable {
        var coins = [DisplayedCoin]()
        var loading = false
    }

    enum Action {
        case addNewCoinButtonTapped
        case onAppear
        case onAppearResponse(coins: [DisplayedCoin])
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .addNewCoinButtonTapped:
                addNewCoin(&state)
                return .none

            case .onAppear:
                state.loading = true
                return .run { send in
                    let coins = try await fetchCoins()
                    await send(.onAppearResponse(coins: coins))
                }

            case .onAppearResponse(let coins):
                state.loading = false
                state.coins = coins
                return .none
            }

        }
    }
}

private extension ListCoinsFeature {
    func addNewCoin(_ state: inout ListCoinsFeature.State) {
//        state.coins.append(.init(id: "julia", name: "julia", symbol: "oi"))
    }

    func fetchCoins() async throws -> [DisplayedCoin] {
        do {
            let businessCoins = try await coinLoader.fetchCoinList()
            let exchange = try await coinLoader.getDollarExchangeRate()
            let coins = businessCoins.map { CoinMapper.toDisplayed(from: $0, exchange: exchange) }
            try cacheManager.saveInCacheIfNeeded(coins)

            return coins
        } catch is APICallError {
            let cachedCoins = try cacheManager.tryFetchFromCache()

            return cachedCoins
        }
    }
}
