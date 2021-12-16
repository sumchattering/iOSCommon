//
//  UIViewControllerExtensions.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 6/2/21.
//

import Foundation
import UIKit

extension UIViewController {

    var previousViewController: UIViewController? {
        guard let viewControllers = navigationController?.viewControllers, viewControllers.count > 1 else {
            return nil
        }
        guard let myIndex = viewControllers.firstIndex(of: self), myIndex > 0 else {
            return nil
        }
        return viewControllers[myIndex - 1]
    }
    
    func addFullScreenChildViewController(viewController: UIViewController, parentView: UIView? = nil) {
        
        var parentView = parentView
        if (parentView == nil) {
            parentView = self.view
        }
        
        guard let parentView = parentView else {
            return
        }
        
        addChild(viewController)
        parentView.addFullScreenSubview(view: viewController.view)
    }

}
