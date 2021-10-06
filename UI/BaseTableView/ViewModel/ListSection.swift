//
//  ListSection.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 13/02/2019.
//  Copyright © 2019 Sumeru Chatterjee. All rights reserved.
//

import UIKit

struct ListSection {
    var items: [ListItem]

    var headerObject: AnyObject?
    let headerReusableViewType: BaseTableReusableView.Type?

    var footerObject: AnyObject?
    let footerReusableViewType: BaseTableReusableView.Type?

    init(items: [ListItem],
         headerObject: AnyObject? = nil,
         headerReusableViewType: BaseTableReusableView.Type? = nil,
         footerObject: AnyObject? = nil,
         footerReusableViewType: BaseTableReusableView.Type? = nil) {

        self.items = items
        self.headerObject = headerObject
        self.headerReusableViewType = headerReusableViewType

        self.footerObject = footerObject
        self.footerReusableViewType = footerReusableViewType
    }
}
