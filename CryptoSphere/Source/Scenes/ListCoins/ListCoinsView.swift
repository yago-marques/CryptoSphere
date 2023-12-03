import ComposableArchitecture
import SwiftUI

struct ListCoinsView: View {
    let store: StoreOf<ListCoinsFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                if viewStore.cacheUsed {
                    Text(viewStore.cacheMessage)
                        .foregroundStyle(DS.fontColors.secondary)
                        .multilineTextAlignment(.center)
                        .padding([.leading, .trailing], 20)
                }
                if viewStore.internetErrorAndCacheNotAvailable {
                    DS.components.internetErrorView(message: viewStore.internetErrorMessage)
                } else {
                    List(viewStore.coins) { coin in
                        DS.components.coinCard(for: coin)
                            .listRowSeparator(.hidden)
                            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                    .navigationTitle("Trending coins")
                    .navigationBarTitleDisplayMode(.inline)
                    .listStyle(.plain)
                    .background(DS.backgrounds.secondary)
                }
            }
            .overlay {
                if viewStore.loading {
                    ProgressView()
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}
