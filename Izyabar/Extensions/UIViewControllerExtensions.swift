//
//  UIViewControllerExtensions.swift
//  Izyabar
//
//  Created by Izya Pitersky on 3/16/21.
//

import Foundation
import UIKit

extension UIViewController {
    func showErrorDialogFor(_ error: CocktailError, retryHandler: (() -> Void)? = nil) {
        let alertVC = UIAlertController(
            title: error.title(),
            message: error.message(),
            preferredStyle: .alert
        )
        alertVC.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: nil))
        if retryHandler != nil {
            alertVC.addAction(UIAlertAction(title: "retry".localized, style: .default) { _ in
                retryHandler?()
            })
        }
        present(alertVC, animated: true)
    }
}
