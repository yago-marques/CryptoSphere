//
//  TextPicker.swift
//  CryptoSphere
//
//  Created by Yago Marques on 30/11/23.
//

import SwiftUI

struct TextPicker: View {
    @Binding var text: String
    let title: String
    let placeholder: String

    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .foregroundStyle(DS.fontColors.primary)
                    .padding(.leading, 10)
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width * 0.9)
            VStack {
                TextField(placeholder, text: $text)
                    .padding()
            }
            .background(DS.backgrounds.tertiary)
            .frame(width: UIScreen.main.bounds.width * 0.9)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}
