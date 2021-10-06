//
//  UITextViewExtensions.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 6/9/21.
//

import Foundation
import UIKit
import Combine

extension UITextView {
    func textPublisher(prepend: String? = nil) -> AnyPublisher<String, Never> {
        if let prepend = prepend {
            return NotificationCenter.default
                .publisher(for: UITextView.textDidChangeNotification, object: self)
                .map { ($0.object as? UITextView)?.text  ?? "" }
                .prepend(prepend)
                .eraseToAnyPublisher()
        } else {
            return NotificationCenter.default
                .publisher(for: UITextView.textDidChangeNotification, object: self)
                .map { ($0.object as? UITextView)?.text  ?? "" }
                .eraseToAnyPublisher()
        }
    }
}
