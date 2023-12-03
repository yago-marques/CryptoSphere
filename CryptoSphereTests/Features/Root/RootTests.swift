//
//  RootTests.swift
//  CryptoSphereTests
//
//  Created by Yago Marques on 03/12/23.
//

import ComposableArchitecture
import XCTest
@testable import CryptoSphere

typealias RootTestsFeatureSUT = (
    sut: TestStore<RootFeature.State, RootFeature.Action>,
    useCases: RootUseCasesMock
)

@MainActor
final class RootTests: XCTestCase {
    func test_onAppear_WhenIsFirstAccess_ShouldDisplayFirstAccessFlux() async {
        let (sut, useCases) = makeSUT()
        useCases.firstAccess = true

        await sut.send(.onAppear) { state in
            state.isFirstAccess = true
        }
    }

    func test_onAppear_WhenIsNotFirstAccess_ShouldDoNothing() async {
        let (sut, _) = makeSUT()

        await sut.send(.onAppear)
    }
}

private extension RootTests {
    func makeSUT() -> RootTestsFeatureSUT {
        let useCases = RootUseCasesMock()
        let store = TestStore(initialState: RootFeature.State()) {
            RootFeature(useCases: useCases)
        }

        return (store, useCases)
    }
}
