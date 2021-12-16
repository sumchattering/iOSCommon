//
//  BaseCollectionReusableView.swift
//  iOSCommon
//
//  Created by Sumeru Chatterjee on 13/02/2019.
//  Copyright © 2019 Sumeru Chatterjee. All rights reserved.
//

import UIKit

protocol BaseCollectionReusableView {
            
    func configure(withObject object: AnyObject?)
    
}

extension BaseCollectionReusableView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }

    static var hasNib: Bool {
        return Bundle.main.path(forResource: reuseIdentifier, ofType: "nib") != nil
    }

}
