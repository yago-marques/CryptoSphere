//
//  String+.swift
//  CryptoSphere
//
//  Created by Yago Marques on 28/11/23.
//

import Foundation

extension String {
    func roundedDollarFormat() -> String {
        var validNumbers = 0
        var word = String()

        for char in self where validNumbers < 2 {
            if char != "0", char != "." {
                validNumbers += 1
            }
            if char != "." {
                word.append(char)
            } else {
                word.append(",")
            }
        }

        return word
    }
}
