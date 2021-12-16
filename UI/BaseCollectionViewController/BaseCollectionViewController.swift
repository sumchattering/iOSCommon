//
//  BaseCollectionViewController.swift
//  Inter
//
//  Created by Sumeru Chatterjee on 10/8/21.
//

import UIKit

class BaseCollectionViewController: BaseViewController, BaseCollectionViewDelegate {

    var collectionView: BaseCollectionView!
    var collectionViewOverlayView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView = BaseCollectionView(frame: .zero)
        self.collectionView.cvDelegate = self
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.clipsToBounds = false
        self.collectionView.allowsMultipleSelectionDuringEditing = false
        
        let constraints = self.view.addFullScreenSubview(view: self.collectionView)
        self.keyboardConstraint = constraints[2]
        
        self.collectionViewOverlayView = UIView(frame: .zero)
        self.collectionViewOverlayView.backgroundColor = self.collectionView.backgroundColor
        self.collectionViewOverlayView.isHidden = true
        self.view.addFullScreenSubview(view: self.collectionViewOverlayView)
        
    }
    
    override func initialize() {
        super.initialize()
        
        if self.hidesNavigationBar {
            var contentInset: UIEdgeInsets = .zero
            contentInset.top += .margin * 3
            self.collectionView.contentInset = contentInset
        }
    }

    @objc func onRefresh() {
        self.refresh()
    }
    
    func refresh() {
        // to be overridden
    }
    
    var activityView: UIActivityIndicatorView?
    
    func showActivityIndicator() {
        guard self.activityView == nil else {
            return
        }
        
        if self.label != nil {
            self.hideLabel()
        }
        
        let activityView = UIActivityIndicatorView(style: .medium)
        self.collectionViewOverlayView.addCenteredSubview(view: activityView)
        activityView.startAnimating()
        self.activityView = activityView
        self.collectionViewOverlayView.isHidden = false
    }
    
    func hideActivityIndicator() {
        guard let activityView = self.activityView else {
            return
        }
        
        activityView.removeFromSuperview()
        self.activityView = nil
        self.collectionViewOverlayView.isHidden = (self.collectionViewOverlayView.subviews.count == 0)
    }
    
    var label: UILabel?
    
    func showLabel(text: String) {
        guard self.label == nil else {
            return
        }
        
        if self.activityView != nil {
            self.hideActivityIndicator()
        }
        
        let label = UILabel()
        label.textColor = .backgroundLabel
        label.font = .description
        label.text = text
        label.numberOfLines = 0
        label.textAlignment = .center
        self.collectionViewOverlayView.addCenteredSubview(view: label, widthOffset: -4 * .margin)
        self.label = label
        self.collectionViewOverlayView.isHidden = false
    }
    
    func hideLabel() {
        guard let label = self.label else {
            return
        }
        
        label.removeFromSuperview()
        self.label = nil
        self.collectionViewOverlayView.isHidden = (self.collectionViewOverlayView.subviews.count == 0)
    }

}
