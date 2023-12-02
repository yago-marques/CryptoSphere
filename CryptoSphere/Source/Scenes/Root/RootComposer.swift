import SwiftUI
import ComposableArchitecture

enum RootComposer {
    static func make() -> some View {
        let useCases = UserPreferencesWorker()
        let store = Store(initialState: RootFeature.State()) {
            RootFeature(useCases: useCases)
        }
        let view = RootView(store: store)

        return view
    }
}
