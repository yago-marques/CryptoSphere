import ComposableArchitecture
import XCTest
@testable import CryptoSphere


typealias WalletFeatureSUT = (
    sut: TestStore<WalletFeature.State, WalletFeature.Action>,
    useCases: WalletFeatureUseCasesStub
)

@MainActor
final class WalletFeatureTests: XCTestCase {
    func testOnAppear_WhenInternetIsOKAndRemoteWalletsIsNotEmpty_ShouldDisplayWallets() async {
        let (sut, useCases) = makeSUT()

        await sut.send(.onAppear) { state in
            state.loading = true
        }

        await sut.receive(\.updateTable)

        await sut.receive(\.emptyWallets) { state in
            state.emptyWallets = true
        }

        await sut.receive(\.onAppearResponse) { state in
            state.loading = false
            state.wallets = useCases.wallets.map { WalletMapper.toDisplayed(from: $0) }
        }
    }
}

private extension WalletFeatureTests {
    func makeSUT() -> WalletFeatureSUT {
        let useCases = WalletFeatureUseCasesStub()
        let store = TestStore(initialState: WalletFeature.State()) {
            WalletFeature(useCases: useCases)
        }

        return (store, useCases)
    }
}
