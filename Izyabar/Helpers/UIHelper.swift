//
//  UIHelper.swift
//  Izyabar
//
//  Created by Izya Pitersky on 3/7/21.
//

import Foundation
import UIKit

struct UIHelper {
    
    // MARK: - Public methods
    static func applyImageInsetsAndConstraints(for loginButton: UIButton, rootView: UIView?) {
        loginButton.imageEdgeInsets = UIEdgeInsets(
            top: Constants.insetTop,
            left: Constants.insetLeft,
            bottom: Constants.insetBottom,
            right: Constants.insetRight
        )
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(createConstraints(for: loginButton, rootView: rootView))
    }
    
    static func setupGradient(for shadowView: UIView) {
        let gradient = CAGradientLayer()
        
        gradient.frame = shadowView.bounds
        let startColor = UIColor(red: 241/255, green: 241/255, blue: 243/255, alpha: 1).cgColor
        let endColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor
        gradient.colors = [startColor, endColor]
        
        shadowView.layer.insertSublayer(gradient, at: 0)
    }
    
    // MARK: - Private methods
    private static func createConstraints(for loginButton: UIView, rootView: UIView?) -> [NSLayoutConstraint] {
        
        let trailingContraint = NSLayoutConstraint(item: loginButton,
                                                   attribute: .trailingMargin,
                                                   relatedBy: .equal,
                                                   toItem: rootView,
                                                   attribute: .trailingMargin,
                                                   multiplier: 1.0,
                                                   constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(item: loginButton,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: rootView,
                                                  attribute: .bottom,
                                                  multiplier: 1.0,
                                                  constant: 0)
        
        let widthConstraint = NSLayoutConstraint(item: loginButton,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1.0,
                                                 constant: Constants.buttonWidth)
        
        let heightConstraint = NSLayoutConstraint(item: loginButton,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1.0,
                                                  constant: Constants.buttonHeight)
        
        return [trailingContraint, bottomConstraint, widthConstraint, heightConstraint]
    }
    
    private enum Constants {
        fileprivate static let insetTop = CGFloat(10)
        fileprivate static let insetLeft = CGFloat(10)
        fileprivate static let insetBottom = CGFloat(9)
        fileprivate static let insetRight = CGFloat(16)
        
        private static let imageDimension = CGFloat(35)
        fileprivate static let buttonWidth = imageDimension + insetLeft + insetRight
        fileprivate static let buttonHeight = imageDimension + insetTop + insetBottom
    }
}
