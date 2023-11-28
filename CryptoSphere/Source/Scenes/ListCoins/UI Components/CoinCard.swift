//
//  CoinCard.swift
//  CryptoSphere
//
//  Created by Yago Marques on 28/11/23.
//

import SwiftUI

struct CoinCard: View {
    let coin: DisplayedCoin
    @State var image = Image.defaultCoinImage

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
        }
        .padding([.top, .bottom], 10)
        .frame(width: UIScreen.main.bounds.width)
        .background(DS.backgrounds.secondary)
        .task {
            await image.download(from: coin.imageUrl)
        }
    }

    var coinImage: some View {
        image
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

#Preview {
    ListCoinsView(
        store: .init( initialState: ListCoinsFeature.State()) {
            ListCoinsFeature(
                coinLoader:
                    RemoteCoinLoaderService(
                        httpClient: URLSessionHTTPClient(session: URLSession.shared)
                    ), cacheManager: CoinCacheManager()
            )
        }
    )
}
