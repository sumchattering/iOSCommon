//
//  NibLoadingView.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 6/4/21.
//

import Foundation
import UIKit
/**
 Subclass your UIView from NibLoadView to automatically load a xib with the same name as your class.
 Keep in mind to set file's owner to class, and connect a referencing outlet from the root view to the file's owner, and leave the root view's custom class empty.
 */
protocol NibDefinable {
    var nibName: String { get }
}

protocol NibDefinableView: AnyObject, NibDefinable {
    var view: UIView! { get set }
}

extension NibDefinableView where Self: UIView {
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return nibView
    }
    
    fileprivate func reloadFromNibImpl() {
        // Remove all subviews from the view
        view.subviews.forEach { $0.removeFromSuperview() }
        
        // Set the view to nil
        view = nil
        
        // And load it again
        nibSetup()
    }
    
    fileprivate func nibSetup() {
        backgroundColor = .clear
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        
        addSubview(view)
    }
}

@IBDesignable
class NibLoadingView: UIView, NibDefinableView {
    
    @IBOutlet weak var view: UIView!
    
    var nibName: String {
        return String(describing: type(of: self))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
        awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    func reloadFromNib() {
        reloadFromNibImpl()
    }
}
