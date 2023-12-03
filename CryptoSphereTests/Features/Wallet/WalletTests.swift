import ComposableArchitecture
import XCTest
@testable import CryptoSphere


typealias WalletFeatureSUT = (
    sut: TestStore<WalletFeature.State, WalletFeature.Action>,
    doubles: (WalletFeatureUseCasesStub, InternetVerifierMock)
)

@MainActor
final class WalletFeatureTests: XCTestCase {
    // MARK: onAppear
    func testOnAppear_WhenInternetIsOKAndRemoteWalletsIsNotEmpty_ShouldDisplayWallets() async {
        let (sut, (useCases, _)) = makeSUT()
        useCases.populate()

        await sut.send(.onAppear) { state in
            state.loading = true
        }

        await sut.receive(\.updateTable)

        await sut.receive(\.emptyWallets)

        await sut.receive(\.onAppearResponse) { state in
            state.loading = false
            state.wallets = useCases.displayedWallets
        }
    }

    func testOnAppear_WhenInternetIsOKAndRemoteWalletsIsEmpty_ShouldDisplayEmptyWalletsMessage() async {
        let (sut, _) = makeSUT()

        await sut.send(.onAppear) { state in
            state.loading = true
        }

        await sut.receive(\.updateTable)

        await sut.receive(\.emptyWallets) { state in
            state.emptyWallets = true
        }

        await sut.receive(\.onAppearResponse) { state in
            state.loading = false
            state.wallets = []
        }
    }

    func testOnAppear_WhenInternetIsNotOK_ShouldDisplayInternetErrorMessage() async {
        let (sut, (_, internetVerifier)) = makeSUT()
        internetVerifier.internetActivated = false

        await sut.send(.onAppear) { state in
            state.loading = true
        }

        await sut.receive(\.updateTable)

        await sut.receive(\.registerInternetError) { state in
            state.loading = false
            state.internetError = true
        }
    }

    func testOnAppear_WhenWalletsStateIsNotEmpty_ShouldDoNothing() async {
        let (sut, (useCases, _)) = makeSUT()
        useCases.populate()

        await sut.send(.onAppear) { state in
            state.loading = true
        }

        await sut.receive(\.updateTable)

        await sut.receive(\.emptyWallets)

        await sut.receive(\.onAppearResponse) { state in
            state.loading = false
            state.wallets = useCases.displayedWallets
        }

        await sut.send(.onAppear)
    }

    // MARK: openCoinPicker
    func testOpenCoinPicker_ShouldPresentCoinPicker() async {
        let (sut, _) = makeSUT()
        let walletToAddCoins = DisplayedWallet(id: "teste", name: "", image: "", coins: [])

        await sut.send(.openCoinPicker(walletToAddCoins)) { state in
            state.walletToEdit = walletToAddCoins
            state.shouldPresentCoinPicker = true
        }
    }

    // MARK: closePicker
    func testClosePicker_ShouldDismissCoinPicker() async {
        let (sut, _) = makeSUT()

        let walletToAddCoins = DisplayedWallet(id: "teste", name: "", image: "", coins: [])

        await sut.send(.openCoinPicker(walletToAddCoins)) { state in
            state.walletToEdit = walletToAddCoins
            state.shouldPresentCoinPicker = true
        }

        await sut.send(.closePicker) { state in
            state.shouldPresentCoinPicker = false
        }
    }

    // MARK: openWalletManager
    func testOpenWalletManager_ShouldPresentWalletManager() async {
        let (sut, _) = makeSUT()

        await sut.send(.openWalletManager) { state in
            state.shouldPresentWalletManager = true
        }
    }

    // MARK: closeWalletmanager
    func testCloseWalletmanager_ShouldDismissWalletManager() async {
        let (sut, _) = makeSUT()

        await sut.send(.openWalletManager) { state in
            state.shouldPresentWalletManager = true
        }

        await sut.send(.closeWalletmanager) { state in
            state.shouldPresentWalletManager = false
        }
    }

    // MARK: openWalletManagerToEdit
    func testOpenWalletManagerToEdit_ShouldPresentWalletManagerToEdit() async {
        let (sut, _) = makeSUT()
        let walletToEdit = DisplayedWallet(id: "teste", name: "", image: "", coins: [])

        await sut.send(.openWalletManagerToEdit(wallet: walletToEdit)) { state in
            state.walletToEdit = walletToEdit
            state.shouldPresentWalletManagerToEdit = true
        }
    }

    // MARK: closeWalletmanagerToEdit
    func testCloseWalletmanagerToEdit_ShouldDismissWalletManagerToEdit() async {
        let (sut, _) = makeSUT()
        let walletToEdit = DisplayedWallet(id: "", name: "", image: "", coins: [])

        await sut.send(.openWalletManagerToEdit(wallet: walletToEdit)) { state in
            state.walletToEdit = walletToEdit
            state.shouldPresentWalletManagerToEdit = true
        }

        await sut.send(.closeWalletmanagerToEdit) { state in
            state.shouldPresentWalletManagerToEdit = false
        }
    }

    // MARK: createNewWallet
    func testCreateNewWallet_WhenInternetIsConnected_ShouldUpdateTable() async {
        let (sut, (useCases, _)) = makeSUT()
        let walletToCreate = Wallet(id: "", name: "", image: "", coins: [])

        await sut.send(.openWalletManager) { state in
            state.shouldPresentWalletManager = true
        }

        await sut.send(.createNewWallet(walletToCreate))

        await sut.receive(\.closeWalletmanager) { state in
            state.shouldPresentWalletManager = false
        }

        await sut.receive(\.updateTable) { state in
            state.loading = true
        }

        await sut.receive(\.emptyWallets)

        await sut.receive(\.onAppearResponse) { state in
            state.loading = false
            state.wallets = useCases.displayedWallets
        }
    }

    func testCreateNewWallet_WhenInternetIsNotConnected_ShouldDisplayErrorMessage() async {
        let (sut, (_, internetVerifier)) = makeSUT()
        internetVerifier.internetActivated = false
        let walletToCreate = Wallet(id: "", name: "", image: "", coins: [])

        await sut.send(.openWalletManager) { state in
            state.shouldPresentWalletManager = true
        }

        await sut.send(.createNewWallet(walletToCreate))

        await sut.receive(\.registerInternetError) { state in
            state.internetError = true
        }
    }

    // MARK: updateWallet
    func testUpdateWallet_WhenInternetIsConnected_ShouldUpdateTable() async {
        let (sut, (useCases, _)) = makeSUT()
        useCases.populate()
        let walletToUpdate = useCases.wallets.first!
        let displayedWalletToUpdate = useCases.displayedWallets.first!

        await sut.send(.openWalletManagerToEdit(wallet: displayedWalletToUpdate)) { state in
            state.walletToEdit = displayedWalletToUpdate
            state.shouldPresentWalletManagerToEdit = true
        }

        await sut.send(.updateWallet(walletToUpdate))

        await sut.receive(\.closeWalletmanagerToEdit) { state in
            state.shouldPresentWalletManagerToEdit = false
        }

        await sut.receive(\.updateTable) { state in
            state.loading = true
        }

        await sut.receive(\.emptyWallets)

        await sut.receive(\.onAppearResponse) { state in
            state.loading = false
            state.wallets = useCases.displayedWallets
        }
    }

    func testUpdateWallet_WhenInternetIsNotConnected_ShouldDisplayErrorMessage() async {
        let (sut, (useCases, internetVerifier)) = makeSUT()
        internetVerifier.internetActivated = false
        useCases.populate()
        let walletToUpdate = useCases.wallets.first!
        let displayedWalletToUpdate = useCases.displayedWallets.first!

        await sut.send(.openWalletManagerToEdit(wallet: displayedWalletToUpdate)) { state in
            state.walletToEdit = displayedWalletToUpdate
            state.shouldPresentWalletManagerToEdit = true
        }

        await sut.send(.updateWallet(walletToUpdate))

        await sut.receive(\.registerInternetError) { state in
            state.internetError = true
        }
    }

    // MARK: registerNewCoins
    func testRegisterNewCoins_WhenInternetIsConnected_ShouldUpdateTable() async {
        let (sut, (useCases, _)) = makeSUT()
        useCases.populate()
        let walletToUpdate = useCases.wallets.first!
        let displayedWalletToUpdate = useCases.displayedWallets.first!

        await sut.send(.openCoinPicker(displayedWalletToUpdate)) { state in
            state.walletToEdit = displayedWalletToUpdate
            state.shouldPresentCoinPicker = true
        }

        await sut.send(.registerNewCoins(walletToUpdate.coins, displayedWalletToUpdate))

        await sut.receive(\.closePicker) { state in
            state.shouldPresentCoinPicker = false
        }

        await sut.receive(\.updateTable) { state in
            state.loading = true
        }

        await sut.receive(\.emptyWallets)

        await sut.receive(\.onAppearResponse) { state in
            state.loading = false
            state.wallets = useCases.displayedWallets
        }
    }

    func testRegisterNewCoins_WhenInternetIsNotConnected_ShouldDisplayErrorMessage() async {
        let (sut, (useCases, internetVerifier)) = makeSUT()
        internetVerifier.internetActivated = false
        useCases.populate()
        let walletToUpdate = useCases.wallets.first!
        let displayedWalletToUpdate = useCases.displayedWallets.first!

        await sut.send(.openCoinPicker(displayedWalletToUpdate)) { state in
            state.walletToEdit = displayedWalletToUpdate
            state.shouldPresentCoinPicker = true
        }

        await sut.send(.registerNewCoins(walletToUpdate.coins, displayedWalletToUpdate))

        await sut.receive(\.registerInternetError) { state in
            state.internetError = true
        }
    }

    // MARK: removeWallet
    func testRemoveWallet_WhenInternetIsConnected_ShouldUpdateTable() async {
        let (sut, (useCases, _)) = makeSUT()
        useCases.populate()
        let walletToDelete = useCases.wallets.first!

        await sut.send(.removeWallet(id: walletToDelete.id))

        await sut.receive(\.updateTable) { state in
            state.loading = true
        }

        await sut.receive(\.emptyWallets)

        await sut.receive(\.onAppearResponse) { state in
            state.loading = false
            state.wallets = useCases.displayedWallets
        }
    }

    func testRemoveWallet_WhenInternetIsNotConnected_ShouldDisplayErrorMessage() async {
        let (sut, (useCases, internetVerifier)) = makeSUT()
        internetVerifier.internetActivated = false
        useCases.populate()
        let walletToDelete = useCases.wallets.first!

        await sut.send(.removeWallet(id: walletToDelete.id))

        await sut.receive(\.registerInternetError) { state in
            state.internetError = true
        }
    }

    // MARK: openWalletDetail
    func testOpenWalletDetail_ShouldPresentWalletDetail() async {
        let (sut, _) = makeSUT()
        let walletToSee = DisplayedWallet(id: "", name: "", image: "", coins: [])

        await sut.send(.openWalletDetail(walletToSee)) { state in
            state.walletToSee = walletToSee
            state.shouldPresentWalletDetail = true
        }
    }

    // MARK: closeWalletDetail
    func testCloseWalletDetail_ShouldDismissWalletDetail() async {
        let (sut, _) = makeSUT()
        let walletToSee = DisplayedWallet(id: "", name: "", image: "", coins: [])

        await sut.send(.openWalletDetail(walletToSee)) { state in
            state.walletToSee = walletToSee
            state.shouldPresentWalletDetail = true
        }

        await sut.send(.closeWalletDetail) { state in
            state.shouldPresentWalletDetail = false
        }
    }
}

private extension WalletFeatureTests {
    func makeSUT() -> WalletFeatureSUT {
        let useCases = WalletFeatureUseCasesStub()
        let internetVerifier = InternetVerifierMock()
        let store = TestStore(initialState: WalletFeature.State()) {
            WalletFeature(useCases: useCases, internetVerifier: internetVerifier)
        }

        return (store, (useCases, internetVerifier))
    }
}
