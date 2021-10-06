//
//  ListItem.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 13/02/2019.
//  Copyright © 2019 Sumeru Chatterjee. All rights reserved.
//

import Foundation
import UIKit

enum ListItemSwipeActionType {
    case plain
    case delete
}

struct ListItemSwipeAction {
    
    let title: String
    let type: ListItemSwipeActionType
    let color: UIColor
    let handler: (AnyObject)->()

    init(title: String,
         type: ListItemSwipeActionType = .plain,
         color: UIColor = .destructiveRed,
         handler: @escaping (AnyObject)->()) {
        self.title = title
        self.handler = handler
        self.type = type
        self.color = color
    }
}

struct ListItem {

    let object: AnyObject
    let cellClass:  BaseTableViewCell.Type?
    let swipeAction: ListItemSwipeAction?
    let selectHandler: (((AnyObject))->())?
    
    init(object: AnyObject,
         cellClass: BaseTableViewCell.Type? = nil,
         swipeAction: ListItemSwipeAction? = nil,
         selectHandler: ((AnyObject)->())? = nil) {
        self.object = object
        self.cellClass = cellClass
        self.swipeAction = swipeAction
        self.selectHandler = selectHandler
    }
    
}

protocol CustomTableObject {
    var cellClass: BaseTableViewCell.Type { get }
}
