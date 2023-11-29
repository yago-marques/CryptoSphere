//
//  Image+.swift
//  CryptoSphere
//
//  Created by Yago Marques on 27/11/23.
//

import SwiftUI

extension Image {
    static var defaultCoinImage: Image {
        return Image("defaultCoin")
    }

    static var defaultCoinImageData: Data {
        return UIImage(named:"defaultCoin")!.pngData()!
    }

    mutating func download(from imagrUrl: String) async {
        guard let url = URL(string: imagrUrl) else { 
            self = Image.defaultCoinImage
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            self = Image(uiImage: .init(data: data) ?? .init(named: "defaultCoin")!)
        } catch {
            self = Image.defaultCoinImage
        }
    }
}

