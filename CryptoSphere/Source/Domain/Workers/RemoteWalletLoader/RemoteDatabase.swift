import FirebaseFirestore

struct RemoteDatabase {
    let database: Firestore

    func save(_ wallet: RemoteWallet)
}
