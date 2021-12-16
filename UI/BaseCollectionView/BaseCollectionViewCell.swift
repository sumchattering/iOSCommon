//
//  BaseCollectionViewCell.swift
//  Athos
//
//  Created by Sumeru Chatterjee on 13/02/2019.
//  Copyright © 2019 Sumeru Chatterjee. All rights reserved.
//

import UIKit

protocol BaseCollectionViewCell {
    
    func configure(withObject object: AnyObject?)

}

extension BaseCollectionViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var hasNib: Bool {
        return Bundle.main.path(forResource: reuseIdentifier, ofType: "nib") != nil
    }
}
