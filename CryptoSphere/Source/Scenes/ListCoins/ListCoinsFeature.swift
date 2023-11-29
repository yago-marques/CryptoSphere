import ComposableArchitecture

@Reducer
struct ListCoinsFeature {
    let fallback: ListCoinsFallbackProtocol

    struct State: Equatable {
        var coins = [DisplayedCoin]()
        var loading = false
        var cacheUsed = false
        var internetErrorAndCacheNotAvailable = false
        var cacheMessage = ""
        var internetErrorMessage = ""
    }

    enum Action: Equatable {
        case onAppear
        case onAppearResponse(coins: [DisplayedCoin])
        case apiFailureAndCacheAvailable(cachedCoins: [DisplayedCoin])
        case setCacheMessage(message: String)
        case apiAndCacheFailure
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.loading = true
                if state.coins.isEmpty {
                    return .run { send in
                        await fetchCoins(send)
                    }
                } else {
                    return .none
                }

            case .onAppearResponse(let coins):
                state.loading = false
                state.coins = coins
                return .none

            case .apiFailureAndCacheAvailable(cachedCoins: let cachedCoins):
                state.loading = false
                if !cachedCoins.isEmpty {
                    state.cacheUsed = true
                    state.coins = cachedCoins
                }
                return .none

            case .setCacheMessage(message: let message):
                state.cacheMessage = message
                return .none

            case .apiAndCacheFailure:
                state.loading = false
                state.internetErrorAndCacheNotAvailable = true
                state.internetErrorMessage = "Connection fail"
                return .none
            }

        }
    }
}

private extension ListCoinsFeature {
    func fetchCoins(_ send: Send<ListCoinsFeature.Action>) async {
        do {
            let coins = try await fallback.primary()

            await send(.onAppearResponse(coins: coins))
        } catch {
            do {
                let (cachedCoins, cacheMessage) = try fallback.secondary()

                await send(.setCacheMessage(message: cacheMessage))
                await send(.apiFailureAndCacheAvailable(cachedCoins: cachedCoins))
            } catch {
                await send(.apiAndCacheFailure)
            }
        }
    }
}
