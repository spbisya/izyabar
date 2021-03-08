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
