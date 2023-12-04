import FirebaseFirestore

protocol ReadToken {
    func readToken() throws -> String
}

struct RemoteDatabase {
    let database: Firestore
    let tokenLoader: ReadToken
    let walletCollectionKey = "wallets"

    init(database: Firestore, tokenLoader: ReadToken) {
        self.database = database
        self.tokenLoader = tokenLoader
    }
}

extension RemoteDatabase: CreateWallet {
    func createWallet(_ wallet: Wallet) async throws {
        let token = try tokenLoader.readToken()

        try await database
            .collection(walletCollectionKey)
            .document(wallet.id)
            .setData(WalletMapper.toDict(from: wallet, ownerToken: token))
    }
}

extension RemoteDatabase: FetchWallets {
    func fetchWallets() async throws -> [Wallet] {
        let token = try tokenLoader.readToken()
        let walletsRef = database
            .collection(walletCollectionKey)
        let query = walletsRef.whereField("owner", isEqualTo: token)
        let res = try await query.getDocuments()

        let wallets = res.documents
            .compactMap { WalletMapper.toBusiness(from: $0.data()) }

        return wallets
    }
}

extension RemoteDatabase: UpdateWallet {
    func updateWallet(_ wallet: Wallet) async throws {
        try await database
            .collection(walletCollectionKey)
            .document(wallet.id)
            .updateData(WalletMapper.toUpdatedDict(from: wallet))
    }
}

extension RemoteDatabase: DeleteWallet {
    func deleteWallet(id: String) async throws {
        try await database
            .collection(walletCollectionKey)
            .document(id)
            .delete()
    }
}
