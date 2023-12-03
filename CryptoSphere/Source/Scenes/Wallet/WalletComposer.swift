import SwiftUI
import ComposableArchitecture
import FirebaseFirestore

enum WalletComposer {
    static func make() -> some View {
        let walletUseCases = RemoteDatabase(
            database: Firestore.firestore(),
            tokenLoader: TokenWorker(repository: KeychainDomain())
        )

        let store = Store(initialState: WalletFeature.State()) {
            WalletFeature(
                useCases: walletUseCases,
                internetVerifier: InternetVerifier.shared
            )
        }

        let view = WalletView(store: store)

        return view
    }
}
