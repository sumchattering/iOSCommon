//
//  UIApplicationExtensions.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 7/6/21.
//

import Foundation
import UIKit

extension UIApplication {
    
    public static var appIdentifier: String {
        return Bundle.main.bundleIdentifier!
    }
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    class func topNavigationController(topViewController: UIViewController? = UIApplication.topViewController()) -> UINavigationController? {
        if let navController = topViewController as? UINavigationController {
            return navController
        }
        
        if let navigationController = topViewController?.navigationController {
            return topNavigationController(topViewController: navigationController)
        }
        
        if let presentingViewController = topViewController?.presentingViewController {
            return topNavigationController(topViewController: presentingViewController)
        }
        
        if let tabBarViewController = topViewController?.tabBarController {
            return topNavigationController(topViewController: tabBarViewController)
        }
        
        return nil
    }
    
}
