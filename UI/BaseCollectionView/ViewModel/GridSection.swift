//
//  GridSection.swift
//  iOSCommon
//
//  Created by Sumeru Chatterjee on 13/02/2019.
//  Copyright © 2019 Sumeru Chatterjee. All rights reserved.
//

import UIKit

class GridSection {
    var items: [GridItem]
    
    var headerObject: AnyObject?
    var headerReusableViewType: BaseCollectionReusableView.Type?
    
    var footerObject: AnyObject?
    var footerReusableViewType: BaseCollectionReusableView.Type?
    
    var sectionInsets: UIEdgeInsets
    
    init(items: [GridItem],
         headerObject: AnyObject? = nil,
         headerReusableViewType: BaseCollectionReusableView.Type? = nil,
         footerObject: AnyObject? = nil,
         footerReusableViewType: BaseCollectionReusableView.Type? = nil,
         sectionInsets: UIEdgeInsets = UIEdgeInsets.zero) {
        
        self.items = items
        self.headerObject = headerObject
        self.headerReusableViewType = headerReusableViewType
        
        self.footerObject = footerObject
        self.footerReusableViewType = footerReusableViewType
        
        self.sectionInsets = sectionInsets
    }
}
