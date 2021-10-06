//
//  BaseTableViewController.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 7/12/21.
//

import UIKit

class BaseTableViewController: BaseViewController, BaseTableViewDelegate {

    var tableView: BaseTableView!
    var tableViewOverlayView: UIView!
    var tableViewStyle: UITableView.Style = .insetGrouped

    var refreshEnabled: Bool = false {
        didSet {
			if refreshEnabled && self.tableView.refreshControl == nil {
				self.tableView.refreshControl = refreshControl
			} else if !refreshEnabled && self.tableView.refreshControl != nil {
				self.tableView.refreshControl = nil
			}
        }
    }
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = BaseTableView(frame: .zero, style: tableViewStyle)
        self.tableView.tvDelegate = self
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.clipsToBounds = false
        self.tableView.allowsMultipleSelectionDuringEditing = false
        
        let constraints = self.view.addFullScreenSubview(view: self.tableView)
        self.keyboardConstraint = constraints[2]
        refreshControl.addTarget(self,
                                 action: #selector(onRefresh),
                                 for: .valueChanged)
        
        
        self.tableViewOverlayView = UIView(frame: .zero)
        self.tableViewOverlayView.backgroundColor = self.tableView.backgroundColor
        self.tableViewOverlayView.isHidden = true
        self.view.addFullScreenSubview(view: self.tableViewOverlayView)
        
    }
    
    override func initialize() {
        super.initialize()
        
        if self.hidesNavigationBar {
            var contentInset: UIEdgeInsets = .zero
            contentInset.top += .margin * 3
            self.tableView.contentInset = contentInset
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
        self.tableViewOverlayView.addCenteredSubview(view: activityView)
        activityView.startAnimating()
        self.activityView = activityView
        self.tableViewOverlayView.isHidden = false
    }
    
    func hideActivityIndicator() {
        guard let activityView = self.activityView else {
            return
        }
        
        activityView.removeFromSuperview()
        self.activityView = nil
        self.tableViewOverlayView.isHidden = (self.tableViewOverlayView.subviews.count == 0)
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
        self.tableViewOverlayView.addCenteredSubview(view: label, widthOffset: -4 * .margin)
        self.label = label
        self.tableViewOverlayView.isHidden = false
    }
    
    func hideLabel() {
        guard let label = self.label else {
            return
        }
        
		label.removeFromSuperview()
        self.label = nil
        self.tableViewOverlayView.isHidden = (self.tableViewOverlayView.subviews.count == 0)
    }

}
