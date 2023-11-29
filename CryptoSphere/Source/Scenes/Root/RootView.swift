import ComposableArchitecture
import SwiftUI

struct RootView: View {
    var body: some View {
        TabView() {
            ListCoinsComposer.make()
                .tabItem {
                    Image(systemName: "bitcoinsign.circle.fill")
                    Text("Coins")
                }

            WalletComposer.make()
                .tabItem {
                    Image(systemName: "mail.stack.fill")
                    Text("Carteira")
                }

        }
    }
}

