//
//  BaseTableView.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 13/02/2019.
//  Copyright © 2019 Sumeru Chatterjee. All rights reserved.
//

import Foundation
import UIKit

class BaseTableView: UITableView {

    weak var tvDelegate: BaseTableViewDelegate?
    var sectionHeaderFont: UIFont?
    var sections: [ListSection] = [] {
        didSet {
    
            var numItems = 0
            for section in sections {
                
                if section.headerObject != nil {
                    estimatedSectionHeaderHeight = UITableView.automaticDimension
                    if let headerClass = section.headerReusableViewType {
                        self.registerReusableView(viewType: headerClass)
                    }
                }
                
                for item in section.items {
                    if let cellClass = item.cellClass {
                        self.register(cellType: cellClass)
                    } else if let customObject = item.object as? CustomTableObject {
                        self.register(cellType: customObject.cellClass)
                    }
                    numItems = numItems + 1
                }
                
                if section.footerObject != nil {
                    estimatedSectionFooterHeight = UITableView.automaticDimension
                    if let footerClass = section.headerReusableViewType {
                        self.registerReusableView(viewType: footerClass)
                    }
                }
            }
            
            self.reloadData()
            self.tvDelegate?.didLoad?(empty: (numItems==0))
        }
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    func setup() {
        self.dataSource = self
        self.delegate = self
        self.rowHeight = UITableView.automaticDimension
        self.sectionHeaderHeight = UITableView.automaticDimension
        self.sectionFooterHeight = UITableView.automaticDimension
        self.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.self.className)
        self.registerReusableView(viewType: BaseHeaderFooterView.self)
        self.registerReusableView(viewType: BaseGroupedHeaderFooterView.self)
    }

    func itemAtIndexPath(_ indexPath: IndexPath) -> ListItem? {
        if indexPath.section < numberOfSections {
            let section = self.sections[indexPath.section]
            if indexPath.item < section.items.count {
                return section.items[indexPath.item]
            }
        }
        return nil
    }
    
    func indexPathForItem(_ indexPath: IndexPath) -> ListItem? {
        if indexPath.section < numberOfSections {
            let section = self.sections[indexPath.section]
            if indexPath.item < section.items.count {
                return section.items[indexPath.item]
            }
        }
        return nil
    }
    
    public func register(cellType: BaseTableViewCell.Type, bundle: Bundle? = nil) {
        let className = cellType.reuseIdentifier
        if cellType.hasNib {
            let nib = UINib(nibName: className, bundle: bundle)
            register(nib, forCellReuseIdentifier: cellType.reuseIdentifier)
        }
    }
    
    public func registerReusableView(viewType: BaseTableReusableView.Type, bundle: Bundle? = nil) {
        let className = viewType.reuseIdentifier
        if viewType.hasNib {
            let nib = UINib(nibName: className, bundle: bundle)
            register(nib, forHeaderFooterViewReuseIdentifier: viewType.reuseIdentifier)
        }
    }

}

// MARK: - UITableViewDataSource

extension BaseTableView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].items.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listItem = self.sections[indexPath.section].items[indexPath.item]
        var cellType = listItem.cellClass
        if cellType == nil, let customObject = listItem.object as? CustomTableObject {
            cellType = customObject.cellClass
        }

        if let cellType = cellType {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath)
            if let baseCell = cell as? BaseTableViewCell {
                baseCell.configure(withObject: listItem.object)
            }
            
            self.tvDelegate?.didLoadCell?(cell: cell, atIndexPath: indexPath)
            return cell
        
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.self.className, for: indexPath)
            if let stringObject = listItem.object as? String {
                cell.textLabel?.text = stringObject
            }
            
            self.tvDelegate?.didLoadCell?(cell: cell, atIndexPath: indexPath)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }

}

// MARK: - UITableViewDelegate

extension BaseTableView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.tvDelegate?.willDisplayCell?(cell: cell, atIndexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        self.tvDelegate?.willDisplayHeader?(view: view, forSection: section)
    }

    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        self.tvDelegate?.willDisplayFooter?(view: view, forSection: section)
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.tvDelegate?.didDisplayCell?(cell: cell, atIndexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = self.sections[section]
        
        var view: UIView?
        if let type = section.headerReusableViewType {
            view = tableView.dequeueReusableHeaderFooterView(withIdentifier: type.reuseIdentifier)
            
        } else if (section.headerObject as? String) != nil, style == .plain {
            view = tableView.dequeueReusableHeaderFooterView(withIdentifier: BaseHeaderFooterView.self.reuseIdentifier)
            
            if let sectionHeaderFont = self.sectionHeaderFont {
                (view as? BaseHeaderFooterView)?.titleLabel.font = sectionHeaderFont
            }
        
        } else if (section.headerObject as? String) != nil, style == .grouped || style == .insetGrouped {
            view = tableView.dequeueReusableHeaderFooterView(withIdentifier: BaseGroupedHeaderFooterView.self.reuseIdentifier)
            if style == .insetGrouped {
                (view as? BaseGroupedHeaderFooterView)?.leadingOffset.constant = .margin + 8
            } else {
                (view as? BaseGroupedHeaderFooterView)?.leadingOffset.constant = 4
            }
            
            if let sectionHeaderFont = self.sectionHeaderFont {
                (view as? BaseGroupedHeaderFooterView)?.titleLabel.font = sectionHeaderFont
            }
        }
        
        if let baseReusableView = view as? BaseTableReusableView {
            baseReusableView.configure(withObject: section.headerObject)
        }
        
        return view
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let section = self.sections[section]
        
        var view: UIView?
        if let type = section.footerReusableViewType {
            view = tableView.dequeueReusableHeaderFooterView(withIdentifier: type.reuseIdentifier)
        } else if (section.footerObject as? String) != nil, style == .plain {
            view = tableView.dequeueReusableHeaderFooterView(withIdentifier: BaseHeaderFooterView.self.reuseIdentifier)
        } else if (section.footerObject as? String) != nil, style == .grouped || style == .insetGrouped {
            view = tableView.dequeueReusableHeaderFooterView(withIdentifier: BaseGroupedHeaderFooterView.self.reuseIdentifier)
        }
        
        if let baseReusableView = view as? BaseTableReusableView {
            baseReusableView.configure(withObject: section.footerObject)
        }
        
        return view
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listItem = self.sections[indexPath.section].items[indexPath.item]
        listItem.selectHandler?(listItem.object)
        self.tvDelegate?.didSelectListItem?(object: listItem.object, indexPath: indexPath)
        self.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let listItem = self.sections[indexPath.section].items[indexPath.item]
        guard let swipeAction = listItem.swipeAction else {
            return nil
        }
        let action = UIContextualAction(style: .normal, title: swipeAction.title, handler: { _, _, success in
            if swipeAction.type == .delete {
                self.beginUpdates()
                var section = self.sections[indexPath.section]
                section.items.remove(at: indexPath.row)
                self.deleteRows(at: [indexPath], with: .fade)
                self.endUpdates()
            }
            swipeAction.handler(listItem.object)
            success(true)
        })
        action.backgroundColor = swipeAction.color
        return UISwipeActionsConfiguration(actions: [action])
    }

}

extension BaseTableView: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.tvDelegate?.didScroll?(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.tvDelegate?.didEndScroll?(scrollView)
    }
}


extension UITableView {
    
}

