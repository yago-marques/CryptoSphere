
import SwiftUI

struct CoinCard: View {
    let coin: DisplayedCoin

    init(for coin: DisplayedCoin) {
        self.coin = coin
    }

    var body: some View {
        HStack {
            HStack {
                coinImage
                coinInfo
                    .padding(.leading)
                Spacer()
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width * 0.9)
            .background(DS.backgrounds.tertiary)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(DS.fontColors.primary)
            }
        }
        .padding([.top, .bottom], 10)
        .frame(width: UIScreen.main.bounds.width)
        .background(DS.backgrounds.secondary)
    }

    var coinImage: some View {
        Image(uiImage: .init(data: coin.image) ?? .init(named: "defaultCoin")!)
            .resizable()
            .clipShape(Circle())
            .background {
                Circle()
                    .foregroundStyle(DS.fontColors.primary)
                    .shadow(
                        color: DS.backgrounds.primary,
                        radius: 10
                    )
            }
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)

    }

    var coinInfo: some View {
        VStack(alignment: .leading) {
            Text(coin.name)
                .foregroundStyle(DS.fontColors.primary)
                .bold()
                .font(.title2)

            Text("Rank position: \(coin.marketRank)")
                .foregroundStyle(DS.fontColors.secondary)

            HStack {
                Text("USD")
                    .bold()
                Text(coin.dollarPrice.roundedDollarFormat())
            }

        }
    }
}
