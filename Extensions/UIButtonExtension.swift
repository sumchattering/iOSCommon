//
//  UIButtonExtension.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 6/7/21.
//

import Foundation
import UIKit

public extension UIButton {
    
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        let image = UIImage(color: color)
        setBackgroundImage(image, for: state)
    }
}
