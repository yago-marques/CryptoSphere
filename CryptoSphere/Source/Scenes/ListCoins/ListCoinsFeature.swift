import ComposableArchitecture

struct DisplayedCoin: Equatable, Identifiable {
    let id: String
    let name: String
    let marketRank: Int
    let imageUrl: String
    let bitcoinPrice: Double
}

@Reducer
struct ListCoinsFeature {
    let coinLoader: CoinLoader

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
        let businessCoins = try await coinLoader.fetchCoinList()
        let coins = businessCoins.map { CoinMapper.toDisplayed(from: $0) }

        return coins
    }
}
