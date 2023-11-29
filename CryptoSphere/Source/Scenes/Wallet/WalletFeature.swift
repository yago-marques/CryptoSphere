import ComposableArchitecture
import Foundation

@Reducer
struct WalletFeature {
    struct State: Equatable {
        var initialMessage = ""
    }

    enum Action: Equatable {
        case onAppear
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.initialMessage = "Hello World"
                return .none
            }
        }
    }
}

