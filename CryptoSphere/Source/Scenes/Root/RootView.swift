import ComposableArchitecture
import SwiftUI

struct RootView: View {
    var body: some View {
        TabView() {
            ListCoinsComposer.make()
                .tabItem {
                    Text("list")
                }

            WalletComposer.make()
                .tabItem {
                    Text("list")
                }
        }
    }
}

