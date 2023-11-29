import Foundation

struct DisplayedCoin: Equatable, Identifiable {
    let id: String
    let name: String
    let marketRank: Int
    let image: Data
    let dollarPrice: String
}
