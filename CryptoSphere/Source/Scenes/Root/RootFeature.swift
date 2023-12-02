import ComposableArchitecture

typealias RootUseCases = VerifyUserFirstAccess

@Reducer
struct RootFeature {
    let useCases: RootUseCases

    struct State: Equatable {
        var isFirstAccess = false
    }

    enum Action: Equatable {
        case onAppear
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if !useCases.verifyUserFirstAccess() {
                    state.isFirstAccess = true
                }
                return .none
            }
        }
    }
}

