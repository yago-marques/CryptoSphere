
import SwiftUI

struct InternetErrorView: View {
    let message: String

    var body: some View {
        VStack {
            Image(systemName: "wifi.slash")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50)
            Text(message)
                .foregroundStyle(DS.fontColors.primary)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
                .bold()
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(DS.backgrounds.secondary)
    }
}
