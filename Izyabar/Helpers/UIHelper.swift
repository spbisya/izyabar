//
//  UIHelper.swift
//  Izyabar
//
//  Created by Izya Pitersky on 3/7/21.
//

import Foundation
import UIKit

struct UIHelper {
    
    //MARK: - Constants
    private static let INSET_TOP = CGFloat(10)
    private static let INSET_LEFT = CGFloat(10)
    private static let INSET_BOTTOM = CGFloat(9)
    private static let INSET_RIGHT = CGFloat(16)
    
    private static let IMAGE_DIMENSION = CGFloat(35)
    private static let BUTTON_WIDTH = IMAGE_DIMENSION + INSET_LEFT + INSET_RIGHT
    private static let BUTTON_HEIGHT = IMAGE_DIMENSION + INSET_TOP + INSET_BOTTOM
    
    //MARK: - Public methods
    
    static func applyImageInsetsAndConstraints(for loginButton: UIButton, rootView: UIView?){
        loginButton.imageEdgeInsets = UIEdgeInsets(top: INSET_TOP, left: INSET_LEFT, bottom: INSET_BOTTOM, right: INSET_RIGHT)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(createConstraints(for: loginButton, rootView: rootView))
    }
    
    static func setupGradient(for shadowView: UIView){
        let gradient = CAGradientLayer()
        
        gradient.frame = shadowView.bounds
        gradient.colors = [UIColor(red: 241/255, green: 241/255, blue: 243/255, alpha: 1).cgColor, UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor]
        
        shadowView.layer.insertSublayer(gradient, at: 0)
    }
    
    //MARK: - Private methods
    private static func createConstraints(for loginButton: UIView, rootView: UIView?) -> Array<NSLayoutConstraint>{
        
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
                                                 constant: BUTTON_WIDTH)
        
        let heightConstraint = NSLayoutConstraint(item: loginButton,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1.0,
                                                  constant: BUTTON_HEIGHT)
        
        return [trailingContraint, bottomConstraint, widthConstraint, heightConstraint]
    }
}
