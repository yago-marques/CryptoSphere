import ComposableArchitecture
import XCTest
@testable import CryptoSphere

typealias ListCoinsFeatureSUT = (
    sut: TestStore<ListCoinsFeature.State, ListCoinsFeature.Action>,
    fallback: ListCoinsFallbackSpy
)

@MainActor
final class ListCoinsTests: XCTestCase {
    func testOnAppear_WhenInternetIsOK_ShouldDisplayCoins() async {
        let (sut, fallback) = makeSUT()

        await sut.send(.onAppear) { state in
            state.loading = true
        }

        await sut.receive(\.onAppearResponse) { state in
            state.loading = false
            state.coins = fallback.coins
        }

        XCTAssertEqual(fallback.receivedMessages, [.primaryCalled])
    }

    func testOnAppear_WhenInternetIsNotOKAndCacheIsValid_ShouldDisplayCachedCoins() async {
        let (sut, fallback) = makeSUT()
        fallback.internetActivated = false

        await sut.send(.onAppear) { state in
            state.loading = true
        }

        await sut.receive(\.setCacheMessage) { state in
            state.cacheMessage = fallback.cachedMessage
        }

        await sut.receive(\.apiFailureAndCacheAvailable) { state in
            state.loading = false
            state.cacheUsed = true
            state.coins = fallback.coins
        }

        XCTAssertEqual(fallback.receivedMessages, [.primaryCalled, .secondaryCalled])
    }

    func testOnAppear_WhenInternetIsNotOKAndCacheIsNotValid_ShouldDisplayErrorMessage() async {
        let (sut, fallback) = makeSUT()
        fallback.internetActivated = false
        fallback.cachePopulated = false

        await sut.send(.onAppear) { state in
            state.loading = true
        }

        await sut.receive(\.apiAndCacheFailure) { state in
            state.loading = false
            state.internetErrorAndCacheNotAvailable = true
            state.internetErrorMessage = "Connection fail"
        }

        XCTAssertEqual(fallback.receivedMessages, [.primaryCalled, .secondaryCalled])
    }

    func testOnAppear_WhenCoinsStateIsNotEmpty_ShouldDoNothing() async {
        let (sut, fallback) = makeSUT()

        await sut.send(.onAppear) { state in
            state.loading = true
        }

        await sut.receive(\.onAppearResponse) { state in
            state.loading = false
            state.coins = fallback.coins
        }

        await sut.send(.onAppear)
    }
}

private extension ListCoinsTests {
    func makeSUT() -> ListCoinsFeatureSUT {
        let fallback = ListCoinsFallbackSpy()
        let store = TestStore(initialState: ListCoinsFeature.State()) {
            ListCoinsFeature(fallback: fallback)
        }

        return (store, fallback)
    }
}
