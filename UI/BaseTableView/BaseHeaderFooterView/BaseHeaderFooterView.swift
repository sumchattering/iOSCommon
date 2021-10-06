//
//  BaseHeaderFooterView.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 6/4/21.
//

import UIKit

class BaseHeaderFooterView: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Theme.theme(self)
    }
    
}

extension BaseHeaderFooterView: BaseTableReusableView {
    
    func configure(withObject object: AnyObject?) {
        guard let title = object as? String else {
            return
        }
        
        titleLabel.text = title
    }

}
