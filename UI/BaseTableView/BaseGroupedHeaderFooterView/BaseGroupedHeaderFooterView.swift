//
//  BaseGroupedHeaderFooterView.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 6/4/21.
//

import UIKit

class BaseGroupedHeaderFooterView: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var leadingOffset: NSLayoutConstraint!
    
    @IBOutlet weak var contentBackgroundView: UIView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        Theme.theme(self)
    }
    
}

extension BaseGroupedHeaderFooterView: BaseTableReusableView {
    
    func configure(withObject object: AnyObject?) {
        guard let title = object as? String else {
            return
        }
        
        titleLabel.text = title
    }

}
