//
//  ListItem.swift
//  iOSCommon
//
//  Created by Sumeru Chatterjee on 13/02/2019.
//  Copyright © 2019 Sumeru Chatterjee. All rights reserved.
//

import Foundation

class GridItem {
    var object: AnyObject?
    var cellClass: BaseCollectionViewCell.Type
    
    init(object: AnyObject?, cellClass: BaseCollectionViewCell.Type) {
        self.object = object
        self.cellClass = cellClass
    }
}
