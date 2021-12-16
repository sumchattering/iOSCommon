//
//  BaseCollectionView.swift
//  iOSCommon
//
//  Created by Sumeru Chatterjee on 13/02/2019.
//  Copyright © 2019 Sumeru Chatterjee. All rights reserved.
//

import UIKit

class BaseCollectionView: UICollectionView {
    
    weak var cvDelegate: BaseCollectionViewDelegate?
    var sections: [GridSection] = [] {
        didSet {
    
            var numItems = 0
            for section in sections {
                
                if section.headerObject != nil {
                    if let headerClass = section.headerReusableViewType {
                        self.registerReusableView(viewType: headerClass)
                    }
                }
                
                for item in section.items {
                    self.register(cellType: item.cellClass)
                    numItems = numItems + 1
                }
                
                if section.footerObject != nil {
                    if let footerClass = section.headerReusableViewType {
                        self.registerReusableView(viewType: footerClass)
                    }
                }
            }
            
            self.reloadData()
            self.cvDelegate?.didLoad?(empty: (numItems==0))
        }
    }
    
    private static func createLayout() -> UICollectionViewLayout {
        let inset: CGFloat = 5

        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 3), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)

        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1 / 3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)

//        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
//        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .top)
//        section.boundarySupplementaryItems = [headerItem]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    convenience init(frame: CGRect) {
        let layout = BaseCollectionView.createLayout()
        self.init(frame: frame, collectionViewLayout: layout)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        self.dataSource = self
        self.delegate = self
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.self.className)
        self.registerReusableView(viewType: BaseCollectionHeaderView.self)
    }
    
    func itemAtIndexPath(_ indexPath: IndexPath) -> GridItem? {
        if indexPath.section < numberOfSections {
            let section = self.sections[indexPath.section]
            if indexPath.item < section.items.count {
                return section.items[indexPath.item]
            }
        }
        return nil
    }
    
    public func register(cellType: BaseCollectionViewCell.Type, bundle: Bundle? = nil) {
        let className = cellType.reuseIdentifier
        if cellType.hasNib {
            let nib = UINib(nibName: className, bundle: bundle)
            register(nib, forCellWithReuseIdentifier: cellType.reuseIdentifier)
        }
    }
    
    public func registerReusableView(viewType: BaseCollectionReusableView.Type, bundle: Bundle? = nil) {
        let className = viewType.reuseIdentifier
        if viewType.hasNib {
            let nib = UINib(nibName: className, bundle: bundle)
            register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: className)
        }
    }
    
}

// MARK: - UICollectionView DataSource

extension BaseCollectionView: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections[section].items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let listItem = self.sections[indexPath.section].items[indexPath.item]
        let cellType = listItem.cellClass
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath)
        
        if let baseCell = cell as? BaseCollectionViewCell, let object = listItem.object {
            // Configure cell content
            baseCell.configure(withObject: object)
        }
        
        if indexPath.section == (self.sections.count - 1) && indexPath.item == (collectionView.numberOfItems(inSection: indexPath.section) - 1) {
            self.cvDelegate?.didScrollToBottom?()
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = self.sections[indexPath.section]
        
        let reuseIdentifier: String
        var object: AnyObject?
        
        if let type = section.headerReusableViewType,
            kind == UICollectionView.elementKindSectionHeader {
            reuseIdentifier = type.reuseIdentifier
            object = section.headerObject
        } else if let type = section.footerReusableViewType,
                      kind == UICollectionView.elementKindSectionFooter {
            reuseIdentifier = type.reuseIdentifier
            object = section.footerObject
        } else {
            reuseIdentifier = BaseCollectionHeaderView.reuseIdentifier
            object = section.headerObject
        }
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        if let baseReusableView = view as? BaseCollectionReusableView {
            baseReusableView.configure(withObject: object)
        }
        
        return view
    }
    
}

// MARK: - UICollectionView Delegate

extension BaseCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let listItem = self.sections[indexPath.section].items[indexPath.item]
        self.cvDelegate?.didSelectListItem?(object: listItem.object)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.cvDelegate?.willDisplayCell?(cell: cell, atIndexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.cvDelegate?.didDisplayCell?(cell: cell, atIndexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionHeader {
            self.cvDelegate?.willDisplayHeader?(view: view, atIndexPath: indexPath)
        } else if elementKind == UICollectionView.elementKindSectionHeader {
            self.cvDelegate?.willDisplayFooter?(view: view, atIndexPath: indexPath)
        }
    }

}

extension BaseCollectionView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.cvDelegate?.didScroll?(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.cvDelegate?.didEndScroll?(scrollView)
    }
}
