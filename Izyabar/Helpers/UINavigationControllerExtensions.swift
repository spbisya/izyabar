//
//  UINavigationControllerExtensions.swift
//  Izyabar
//
//  Created by 1 on 11.03.2021.
//

import Foundation
import UIKit

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
