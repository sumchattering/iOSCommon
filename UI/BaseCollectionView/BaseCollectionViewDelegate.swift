//
//  BaseCollectionViewDelegate.swift
//  Inter
//
//  Created by Sumeru Chatterjee on 10/8/21.
//

import Foundation
import UIKit

@objc protocol BaseCollectionViewDelegate: AnyObject {
    @objc optional func didSelectListItem(object: AnyObject?)
    @objc optional func didScrollToBottom()
    @objc optional func didScroll(_ scrollView: UIScrollView)
    @objc optional func didEndScroll(_ scrollView: UIScrollView)
    @objc optional func didEndScrollingAnimation(_ scrollView: UIScrollView)
    @objc optional func willDisplayCell(cell: UICollectionViewCell, atIndexPath: IndexPath)
    @objc optional func didDisplayCell(cell: UICollectionViewCell, atIndexPath: IndexPath)
    @objc optional func willDisplayHeader(view: UICollectionReusableView, atIndexPath: IndexPath)
    @objc optional func willDisplayFooter(view: UICollectionReusableView, atIndexPath: IndexPath)
    @objc optional func didLoad(empty: Bool)
}
