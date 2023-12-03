//
//  OnboardingView.swift
//  CryptoSphere
//
//  Created by Yago Marques on 30/11/23.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack {
            Text("Welcome to CryptoSphere")
                .bold()
                .font(.title)
                .foregroundStyle(DS.fontColors.primary)
                .multilineTextAlignment(.center)

            Text("Mange your wallet with the most trending market coins")
                .foregroundStyle(DS.fontColors.secondary)
                .multilineTextAlignment(.center)
                .padding(.bottom, 15)

            Button("Start now") {
                viewModel.presentRoot()
            }
            .padding(10)
            .frame(width: UIScreen.main.bounds.width * 0.9)
            .bold()
            .background(DS.backgrounds.action)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .frame(
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height
        )
        .background(DS.backgrounds.secondary)
        .fullScreenCover(isPresented: $viewModel.shouldPresentRoot) {
            RootComposer.make()
        }
        .overlay {
            if viewModel.unexpectedError {
                DS.components.internetErrorView(message: "Unexpected internal error")
            }
        }
    }
}
