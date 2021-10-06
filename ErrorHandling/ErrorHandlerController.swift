//
//  ErrorHandlerController.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 7/6/21.
//

import Foundation
import UIKit

typealias ErrorHandler = (_ error: NSError, _ completion: (() -> ())?) -> Bool

class ErrorHandlerController {
    
    private var defaultHandler: ErrorHandler?
    private var specificErrorHandlers: [Int: ErrorHandler] = [:]
    
    @discardableResult
    func otherwise(handler: @escaping ErrorHandler) -> ErrorHandlerController {
        self.defaultHandler = handler
        return self
    }
    
    @discardableResult
    func on(errorCode: Int, handler: @escaping ErrorHandler) -> ErrorHandlerController {
        self.specificErrorHandlers[errorCode] = handler
        
        return self
    }
    
    @discardableResult
    func handle(error: NSError, completion: (() -> ())? = nil) -> Bool {
        
        var handled = false
        
        if let handler = specificErrorHandlers[error.code] {
            handled = handler(error, completion)
        }
        
        if !handled {
            if let defaultHandler = defaultHandler {
                handled = defaultHandler(error, completion)
            }
        }
        
        if !handled {
            LogError("Unhandled error", error: error)
        }
        
        return handled
    }
}

extension ErrorHandlerController {
    func addGenericErrorHandlers(viewController: UIViewController? = nil) -> ErrorHandlerController {
        return self
            .addGenericErrorHandlersWithoutDefaultHandler(viewController: viewController)
            .addDefaultHandler(viewController: viewController)
    }
    
    func addGenericErrorHandlersWithoutDefaultHandler(viewController: UIViewController?) -> ErrorHandlerController {
        return self
            .addNoInternetHandler(viewController: viewController, consumesError: true)
            .addAutomaticLogoutHandler(errorCode: TradomateAPIResponseCode.Forbidden.rawValue, consumesError: true)
    }
    
    func addDefaultHandler(viewController: UIViewController? = nil) -> ErrorHandlerController {
        return self.otherwise(handler: { (error, completion) -> Bool in
        
            LogError("Default Handler Handled Error", error: error)
            CommonUI.showAlert(showFrom: viewController, error: error, completionHandler: completion)
            //Analytics.track(error: error)
            return true
        })
    }
    
    func addNoInternetHandler(viewController: UIViewController?, consumesError: Bool = true, closeHandler:(()->())? = nil) -> ErrorHandlerController {
        return self.on(errorCode: NSURLErrorNotConnectedToInternet, handler: { (error, completion) -> Bool in
            LogError("No Internet Handler Handled Error", error: error)
            CommonUI.showAlert(showFrom: viewController,
                               title: Strings.Error.noInternetTitle,
                               message: Strings.Error.noInternetText,
                               confirmTitle: Strings.Error.noInternetConfirmTitle)
            return consumesError
        })
    }

    
    func addAutomaticLogoutHandler(errorCode: Int, consumesError: Bool) -> ErrorHandlerController {
        return self.on(errorCode: errorCode, handler: { (error, completion) -> Bool in
            LogError("Automatic Logout Handler Handled Error", error: error)

            RepositoryInjection.provideUserRepository().logout()
            let scene = UIApplication.shared.connectedScenes.first
            if let sceneDelegate: SceneDelegate = (scene?.delegate as? SceneDelegate) {
                sceneDelegate.restart()
            }
            
            completion?()
            return consumesError
        })
    }
    
}
