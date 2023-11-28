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
        var cacheUsed = false
        var internetErrorAndCacheNotAvailable = false
    }

    enum Action {
        case onAppear
        case onAppearResponse(coins: [DisplayedCoin])
        case apiFailureAndCacheAvailable(cachedCoins: [DisplayedCoin])
        case apiAndCacheFailure
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.loading = true
                return .run { send in
                    try await fetchCoins(send)
                }

            case .onAppearResponse(let coins):
                state.loading = false
                state.coins = coins
                return .none

            case .apiFailureAndCacheAvailable(cachedCoins: let cachedCoins):
                state.loading = false
                state.cacheUsed = true
                state.coins = cachedCoins
                return .none

            case .apiAndCacheFailure:
                state.loading = false
                state.internetErrorAndCacheNotAvailable = true
                return .none
            }

        }
    }
}

private extension ListCoinsFeature {
    func fetchCoins(_ send: Send<ListCoinsFeature.Action>) async throws {
        do {
            let businessCoins = try await coinLoader.fetchCoinList()
            let exchange = try await coinLoader.getDollarExchangeRate()
            let coins = businessCoins.map { CoinMapper.toDisplayed(from: $0, exchange: exchange) }
            try cacheManager.saveInCacheIfNeeded(coins)

            await send(.onAppearResponse(coins: coins))
        } catch is APICallError {
            let cachedCoins = try cacheManager.tryFetchFromCache()

            await send(.apiFailureAndCacheAvailable(cachedCoins: cachedCoins))
        } catch {
            await send(.apiAndCacheFailure)
        }
    }


}
