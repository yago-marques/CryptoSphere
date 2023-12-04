
import SwiftUI

struct WalletSeeDetail: View {
    let wallet: DisplayedWallet

    var body: some View {
        ScrollView {
            VStack {
                Image(wallet.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250)
                    .clipShape(Circle())
                Text(wallet.name)
                    .bold()
                    .font(.title)
                    .foregroundStyle(DS.fontColors.primary)
                    .padding(.top, 10)
                    .padding(.bottom, 15)

                HStack {
                    Text("Coins:")
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(DS.fontColors.secondary)
                        .padding(.leading, 35)
                    Spacer()
                }

                ForEach(wallet.coins, id: \.self) { coin in
                    HStack {
                        Image(systemName: "dollarsign.circle.fill")
                            .padding(.leading, 5)
                        Text(coin)
                        Spacer()
                    }
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.85)
                    .background(DS.backgrounds.tertiary)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }

            }
            .padding(.top, 50)


        }
        .frame(width: UIScreen.main.bounds.width)
        .background(DS.backgrounds.secondary)
    }
}
