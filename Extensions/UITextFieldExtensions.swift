//
//  UITextFieldExtensions.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 6/7/21.
//

import Foundation
import UIKit
import Combine

extension UITextField {
    
    func textPublisher(prepend: String? = nil) -> AnyPublisher<String, Never> {
        if let prepend = prepend {
            return NotificationCenter.default
                .publisher(for: UITextField.textDidChangeNotification, object: self)
                .map { ($0.object as? UITextField)?.text  ?? "" }
                .prepend(prepend)
                .eraseToAnyPublisher()
        } else {
            return NotificationCenter.default
                .publisher(for: UITextField.textDidChangeNotification, object: self)
                .map { ($0.object as? UITextField)?.text  ?? "" }
                .eraseToAnyPublisher()
        }
    }
    
}
