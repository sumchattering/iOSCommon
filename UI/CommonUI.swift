//
//  CommonUI.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 7/6/21.
//

import Foundation
import UIKit

class CommonUI {
    
    class func showAlert(showFrom: UIViewController?, error: NSError, completionHandler: (() -> Void)? = nil) {
        showAlert(showFrom: showFrom, title: error.title, message: error.message, confirmTitle: error.confirmTitle, completionHandler: completionHandler)
    }
    
    class func showAlert(showFrom: UIViewController?,
                         title: String?,
                         message: String,
                         cancelTitle: String? = nil,
                         cancelStyle: UIAlertAction.Style = .default,
                         confirmTitle: String,
                         confirmStyle: UIAlertAction.Style = .default,
                         completionHandler: (() -> Void)? = nil) {
        
        var actions = [UIAlertAction]()
        
        if let cancelTitle = cancelTitle {
            actions.append(UIAlertAction(title: cancelTitle, style: cancelStyle, handler: nil))
        }
        
        actions.append(UIAlertAction(title: confirmTitle, style: confirmStyle, handler: { (action) in
            completionHandler?()
        }))
        
        CommonUI.showAlert(fromVC: showFrom, title: title, message: message, actions: actions)
    }
    
    class func showAlert(fromVC: UIViewController?, title: String?, message: String, actions: [UIAlertAction]) {
        if UIApplication.shared.applicationState == UIApplication.State.background {
            LogNotice("Popup not shown because we are in background!")
            return
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        
        if let viewController = fromVC {
            viewController.present(alert, animated: true, completion: nil)
        } else {
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        }
    }
    
}

