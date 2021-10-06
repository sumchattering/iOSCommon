//
//  UIViewExtensions.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 7/12/21.
//

import Foundation
import UIKit

extension UIView {
    
    @discardableResult
    func addFullScreenSubview(view: UIView,
                              margin: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        return view.pinEdges(to: self, margin: margin)
    }
    
    @discardableResult
    func addCenteredSubview(view: UIView,
                            width: CGFloat? = nil,
                            widthOffset: CGFloat? = nil,
                            height: CGFloat? = nil,
                            heightOffset: CGFloat? = nil) -> [NSLayoutConstraint] {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        let constraints = view.center(in: self,
                                      width: width,
                                      widthOffset: widthOffset,
                                      height: height,
                                      heightOffset: heightOffset)
        return constraints
    }
    
    @discardableResult
    private func pinEdges(to other: UIView, margin: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        
        let leftConstraint =
            leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: margin.left)
        let rightConstraint =
            trailingAnchor.constraint(equalTo: other.trailingAnchor, constant: margin.right)
        let topConstraint =
            topAnchor.constraint(equalTo: other.topAnchor, constant: margin.top)
        let bottomConstraint =
            bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: margin.bottom)
        
        let constraints = [topConstraint, leftConstraint, bottomConstraint, rightConstraint]
        constraints.forEach { $0.isActive = true }
        
        return constraints
    }
    
    @discardableResult
    private func center(in other: UIView,
                width: CGFloat? = nil,
                widthOffset: CGFloat?,
                height: CGFloat? = nil,
                heightOffset: CGFloat?) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        let centerXConstraint = centerXAnchor.constraint(equalTo: other.centerXAnchor)
        constraints.append(centerXConstraint)
        
        let centerYConstraint = centerYAnchor.constraint(equalTo: other.centerYAnchor)
        constraints.append(centerYConstraint)
        
        if let width = width {
            let widthConstraint = widthAnchor.constraint(equalToConstant: width)
            constraints.append(widthConstraint)
        }
        
        if let widthOffset = widthOffset {
            let widthConstraint = widthAnchor.constraint(equalTo: other.widthAnchor, constant: widthOffset)
            constraints.append(widthConstraint)
        }
        
        if let height = height {
            let heightConstraint = heightAnchor.constraint(equalToConstant: height)
            constraints.append(heightConstraint)
        }
        
        if let heightOffset = heightOffset {
            let heightConstraint = heightAnchor.constraint(equalTo: other.heightAnchor, constant: heightOffset)
            constraints.append(heightConstraint)
        }
        
        constraints.forEach { $0.isActive = true }
        return constraints
    }
    
    
    func superview<T>(of type: T.Type) -> T? {
        return superview as? T ?? superview?.superview(of: type)
    }

    func subview<T>(of type: T.Type) -> T? {
        return subviews.compactMap { $0 as? T ?? $0.subview(of: type) }.first
    }

}
