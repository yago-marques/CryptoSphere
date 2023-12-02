//
//  OnboardingViewModel.swift
//  CryptoSphere
//
//  Created by Yago Marques on 01/12/23.
//

import Foundation

final class OnboardingViewModel: ObservableObject {
    @Published var shouldPresentRoot = false
    let userPreferences: RegisterFirstUserAccess
    let internalSecurity: RegisterToken

    init(userPreferences: RegisterFirstUserAccess, internalSecurity: RegisterToken) {
        self.userPreferences = userPreferences
        self.internalSecurity = internalSecurity
    }

    func presentRoot() {
        do {
            try internalSecurity.registerToken()
            userPreferences.registerFirstUserAccess()
            shouldPresentRoot = true
        } catch {
            print(error)
        }

    }
}
