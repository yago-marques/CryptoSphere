//
//  OnboardingComposer.swift
//  CryptoSphere
//
//  Created by Yago Marques on 01/12/23.
//

import SwiftUI

enum OnboardingComposer {
    static func make() -> some View {
        let viewModel = OnboardingViewModel(
            userPreferences: UserPreferencesWorker(),
            internalSecurity: TokenWorker(repository: KeychainDomain())
        )

        return OnboardingView(viewModel: viewModel)
    }
}
