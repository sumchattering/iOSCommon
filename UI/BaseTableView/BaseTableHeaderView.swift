//
//  BaseTableHeaderView.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 13/02/2019.
//  Copyright © 2019 Sumeru Chatterjee. All rights reserved.
//

import UIKit

class BaseTableHeaderView: UIView {

    @IBOutlet weak var titleLabel: UILabel!

}

extension BaseTableHeaderView: BaseTableReusableView {

    func configure(withObject object: AnyObject?) {
        guard let title = object as? String else {
            return
        }

        self.titleLabel.text = title
    }

}
