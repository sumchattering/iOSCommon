//
//  AvoidingKeyboardConstraintProtocol.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 6/2/21.
//

import Foundation
import UIKit

protocol AvoidingKeyboardConstraintProtocol: AnyObject {
    var keyboardWillShowObserver: AnyObject? { get set }
    var keyboardWillHideObserver: AnyObject? { get set }
    var bottomKeyboardConstraint: NSLayoutConstraint? { get }
    var defaultSpaceWhenKeyboardIsHidden: CGFloat { get }
}

extension AvoidingKeyboardConstraintProtocol where Self: UIViewController {
    typealias KeyboardShownBlock = (Notification) -> Void
    typealias KeyboardHiddenBlock = (Notification) -> Void

    func addKeyboardObservers(keyboardShownBlock: KeyboardShownBlock? = nil,
                              keyboardHiddenBlock: KeyboardHiddenBlock? = nil) {
        self.keyboardWillShowObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil,
            using: { [weak self] notification in
                self?.keyboardWillAppear(notification)
                keyboardShownBlock?(notification)
        })

        self.keyboardWillHideObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil,
            using: { [weak self] notification in
                self?.keyboardWillDisappear(notification)
                keyboardHiddenBlock?(notification)
        })
    }

    func removeKeyboardObservers() {
        if let keyboardWillShowObserver = self.keyboardWillShowObserver {
            NotificationCenter.default.removeObserver(keyboardWillShowObserver)
        }

        if let keyboardWillHideObserver = self.keyboardWillHideObserver {
            NotificationCenter.default.removeObserver(keyboardWillHideObserver)
        }
    }

    private func keyboardWillAppear(_ notification: Notification) {
        guard let bottomKeyboardConstraint = self.bottomKeyboardConstraint else {
            return
        }

        if let keyboardInfo = notification.userInfo {
            let durationInfo = keyboardInfo[UIResponder.keyboardAnimationDurationUserInfoKey]
            if let duration = (durationInfo as? NSNumber)?.doubleValue,
                let endFrame = (keyboardInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

                UIView.animate(withDuration: duration, animations: {
                    bottomKeyboardConstraint.constant = self.defaultSpaceWhenKeyboardIsHidden + endFrame.size.height
                    self.view.layoutIfNeeded()
                })
            }
        }
    }

    private func keyboardWillDisappear(_ notification: Notification) {
        guard let bottomKeyboardConstraint = self.bottomKeyboardConstraint else {
            return
        }

        if let keyboardInfo = notification.userInfo {
            let durationInfo = keyboardInfo[UIResponder.keyboardAnimationDurationUserInfoKey]
            if let duration = (durationInfo as? NSNumber)?.doubleValue {
                UIView.animate(withDuration: duration, animations: {
                    bottomKeyboardConstraint.constant = self.defaultSpaceWhenKeyboardIsHidden
                    self.view.layoutIfNeeded()
                })
            }
        }
    }

}
