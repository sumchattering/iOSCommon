//
//  BaseCollectionHeaderView.swift
//  iOSCommon
//
//  Created by Sumeru Chatterjee on 13/02/2019.
//  Copyright © 2019 Sumeru Chatterjee. All rights reserved.
//

import UIKit

class BaseCollectionHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
}

extension BaseCollectionHeaderView: BaseCollectionReusableView {
    
    func configure(withObject object: AnyObject?) {
        guard let title = object as? String else {
            return
        }
        
        self.titleLabel.text = title
    }
    
}
