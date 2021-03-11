//
//  KeyboardContentInsetsBuilder.swift
//  Izyabar
//
//  Created by 1 on 11.03.2021.
//

import Foundation
import UIKit

struct KeyboardContentInsetsBuilder {
    static func buildInsetsFor(view: UIView, notification: Notification) -> UIEdgeInsets? {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return nil }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        return notification.name == UIResponder.keyboardWillHideNotification ? .zero :
            UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
    }
}
