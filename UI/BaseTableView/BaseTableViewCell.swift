//
//  BaseTableViewCell.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 13/02/2019.
//  Copyright © 2019 Sumeru Chatterjee. All rights reserved.
//

import UIKit

protocol BaseTableViewCell {

    func configure(withObject object: AnyObject?)

}

extension BaseTableViewCell {

    static var reuseIdentifier: String {
        return String(describing: self)
    }

    static var hasNib: Bool {
        return Bundle.main.path(forResource: reuseIdentifier, ofType: "nib") != nil
    }
}
