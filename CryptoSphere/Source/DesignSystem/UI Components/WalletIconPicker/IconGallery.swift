//
//  AvatarGallery.swift
//  HangSpot
//
//  Created by Yago Marques on 19/11/23.
//

import SwiftUI

struct IconGallery: View {
    @Binding var avatarToModify: String
    @Environment(\.dismiss) var dismiss

    let data = (1...16).map { "w \($0)" }

    let columns = [
        GridItem(.fixed(120)),
        GridItem(.fixed(120)),
        GridItem(.fixed(120))
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 50) {
                    ForEach(data, id: \.self) { item in
                        Image(item, label: Text("avatar"))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 90, height: 90)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .onTapGesture {
                                avatarToModify = item
                                dismiss()
                            }
                    }
                }
                .padding()
            }
            .frame(width: UIScreen.main.bounds.width)
            .background(DS.backgrounds.secondary)
            .navigationTitle("Choose wallet icon")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
