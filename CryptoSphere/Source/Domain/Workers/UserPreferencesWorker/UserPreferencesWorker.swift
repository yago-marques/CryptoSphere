//
//  UserPreferencesWorker.swift
//  CryptoSphere
//
//  Created by Yago Marques on 01/12/23.
//

import Foundation

struct UserPreferencesWorker: RegisterFirstUserAccess, VerifyUserFirstAccess {
    let key = "firstAccess"
    let defaults = UserDefaults.standard

    func registerFirstUserAccess() {
        defaults.set(true, forKey: key)
    }

    func verifyUserFirstAccess() -> Bool {
        defaults.bool(forKey: key)
    }
}
