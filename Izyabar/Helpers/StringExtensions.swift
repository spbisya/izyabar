//
//  StringExtension.swift
//  Izyabar
//
//  Created by 1 on 11.03.2021.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
