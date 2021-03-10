//
//  Extensions.swift
//  Izyabar
//
//  Created by Izya Pitersky on 3/7/21.
//

import Foundation
import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

extension UINavigationController {
    func removeRightButton() {
        let subviews = self.navigationBar.subviews
        subviews.forEach { view in
            if view.tag == Constants.loginButtonTag {
                view.removeFromSuperview()
            }
        }
    }
}

extension UIColor {
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}
