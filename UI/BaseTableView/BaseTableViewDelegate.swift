//
//  BaseTableViewDelegate.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 6/2/21.
//

import Foundation
import UIKit

@objc protocol BaseTableViewDelegate: AnyObject {
    @objc optional func didSelectListItem(object: AnyObject?, indexPath: IndexPath)
    @objc optional func didScroll(_ scrollView: UIScrollView)
    @objc optional func didEndScroll(_ scrollView: UIScrollView)
    @objc optional func didLoadCell(cell: UITableViewCell, atIndexPath: IndexPath)
    @objc optional func willDisplayCell(cell: UITableViewCell, atIndexPath: IndexPath)
    @objc optional func didDisplayCell(cell: UITableViewCell, atIndexPath: IndexPath)
    @objc optional func willDisplayHeader(view: UIView, forSection: Int)
    @objc optional func willDisplayFooter(view: UIView, forSection: Int)
    @objc optional func editingStyle(view: UIView, forSection: Int)
    @objc optional func didLoad(empty: Bool)
}
