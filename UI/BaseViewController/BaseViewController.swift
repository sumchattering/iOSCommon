//
//  BaseViewController.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 6/2/21.
//

import Foundation
import UIKit
import Combine
import ProgressHUD
import FirebaseAnalytics

class BaseViewController: UIViewController {

    let strategiesRepository = RepositoryInjection.provideStrategyRepository()
    let queriesRepository = RepositoryInjection.provideQueryRepository()
    let userRepository = RepositoryInjection.provideUserRepository()
    
    var errorHandler: ErrorHandlerController?
    var keyboardWillShowObserver: AnyObject?
    var keyboardWillHideObserver: AnyObject?
    var defaultBottomSpace: CGFloat = 0.0
    weak var keyboardConstraint: NSLayoutConstraint?
    
    var hidesNavigationBar: Bool = false {
        didSet {
            navigationController?.setNavigationBarHidden(hidesNavigationBar, animated: false)
        }
    }

    weak var currentNavigationController: UINavigationController?

    var hasViewAppeared: Bool = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.errorHandler = ErrorHandlerController().addGenericErrorHandlers(viewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeKeyboardObservers()
        close()
    }

    func initialize() {
        //LogDebug("\(self.className) Initialize \(unsafeBitCast(self, to: Int.self))")
    }

    func resume() {
        //LogDebug("\(self.className) Resume \(unsafeBitCast(self, to: Int.self))")
    }

    func close() {
        //LogDebug("\(self.className) Close \(unsafeBitCast(self, to: Int.self))")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self.keyboardConstraint != nil {
            self.addKeyboardObservers()
        }

        if !hasViewAppeared {
            initialize()
        } else {
            resume()
        }

        hasViewAppeared = true

        currentNavigationController = navigationController
        if self.hidesNavigationBar {
            currentNavigationController?.setNavigationBarHidden(true, animated: true)
        } else if let previousViewController = self.previousViewController as? BaseViewController,
                  previousViewController.hidesNavigationBar == true {
            currentNavigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        trackScreenView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if self.keyboardConstraint != nil {
            self.removeKeyboardObservers()
        }

        if self.hidesNavigationBar {
            currentNavigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    func load<T: Publisher>(_ publisher: T,
                            showLoading: Bool = true,
                            showSuccess: Bool = false,
                            onError: ((Error) -> (Void))? = nil,
                            onValue: ((T.Output) -> ())? = nil) {
        
        if (showLoading) {
            self.showLoading(loading: true)
        }
        
        return publisher
            .bind(target: self, receiveCompletion: { completion in
                
                switch completion {
                case .finished:
                    if showSuccess {
                        self.showSuccess()
                    } else if showLoading {
                        self.showLoading(loading: false)
                    }
                case .failure(let error):
                    self.handle(error: error)
                    onError?(error)
                    if showLoading {
                        self.showLoading(loading: false)
                    }
                }
                
            }, receiveValue: { output in
                onValue?(output)
            })
    }

    func handle(error: Error, completion: (() -> ())? = nil) {
        errorHandler?.handle(error: error as NSError, completion: completion)
    }
    
    func showLoading(loading: Bool) {
        if loading {
            ProgressHUD.show()
        } else {
            ProgressHUD.dismiss()
        }
    }
    
    func showSuccess() {
        ProgressHUD.showSuccess()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            ProgressHUD.dismiss()
        }
    }
    
    func trackScreenView() {
        #if !MOCK && !LOCAL
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [AnalyticsParameterScreenName: getScreenName(),
                                        AnalyticsParameterScreenClass: self.className])

        #endif
    }
    
    private func getScreenName() -> String {
        let className = self.className
        if className.hasSuffixCaseInsensitive("ViewController") {
            return className.dropSuffixCaseInsensitive("ViewController")
        } else if className.hasSuffixCaseInsensitive("Controller") {
            return className.dropSuffixCaseInsensitive("Controller")
        } else {
            return className
        }
    }
}

extension BaseViewController: AvoidingKeyboardConstraintProtocol {

    var bottomKeyboardConstraint: NSLayoutConstraint? {
        return self.keyboardConstraint
    }

    var defaultSpaceWhenKeyboardIsHidden: CGFloat {
        return self.defaultBottomSpace
    }

}
