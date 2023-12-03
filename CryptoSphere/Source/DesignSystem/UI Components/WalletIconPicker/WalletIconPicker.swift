import SwiftUI

struct WalletIconPicker: View {
    @Binding var selectedAvatar: String
    @State var presentGallery = false

    var body: some View {
        Image(selectedAvatar, label: Text("avatar"))
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 250, height: 250)
            .overlay {
                VStack {
                    Spacer()
                    Text("Choose wallet icon")
                        .font(.system(size: 15))
                        .frame(width: 250, height: 50)
                        .background(.thinMaterial, in: Rectangle())
                        .onTapGesture {
                            presentGallery = true
                        }
                }

            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .sheet(isPresented: $presentGallery) {
                DS.components.iconGallery(selectedIcon: $selectedAvatar)
            }
    }
}
