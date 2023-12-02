import ComposableArchitecture
import SwiftUI

struct RootView: View {
    let store: StoreOf<RootFeature>

    init(store: StoreOf<RootFeature>) {
        self.store = store
        setupTabBarStyle()
        setupNavigationBarStyle()
    }

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            if viewStore.isFirstAccess {
                OnboardingComposer.make()
            } else {
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
        .onAppear {
            store.send(.onAppear)
        }
    }

    private func setupTabBarStyle() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().backgroundColor = UIColor(DS.backgrounds.primary)
    }

    private func setupNavigationBarStyle() {
        let appearence = UINavigationBarAppearance()
        appearence.configureWithOpaqueBackground()
        appearence.backgroundColor = UIColor(DS.backgrounds.primary)

        UINavigationBar.appearance().standardAppearance = appearence
        UINavigationBar.appearance().scrollEdgeAppearance = appearence
        UINavigationBar.appearance().compactAppearance = appearence
    }
}

