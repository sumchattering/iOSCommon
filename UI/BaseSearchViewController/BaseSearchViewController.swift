//
//  BaseSearchViewController.swift
//  Tradomate
//
//  Created by Sumeru Chatterjee on 6/4/21.
//

import Foundation
import UIKit

class BaseSearchViewController: BaseTableViewController {
    
    var searchController: UISearchController?
    
    var searchBarPlaceHolder: String = "" {
        didSet {
            navigationItem.searchController?.searchBar.placeholder = searchBarPlaceHolder
        }
    }
    
    var emptyPlaceHolder: ((String?)->(String)) = { searchText in
		if let searchText = searchText {
			return "Could not find any search results for \'\(searchText)\'"
		} else {
			return "Could not find any items"
		}
    }
	
	var errorPlaceholder: ((String?)->(String)) = { searchText in
		if let searchText = searchText {
			return "There was an error loading search results for \'\(searchText)\'"
		} else {
			return "There was an error loading the items"
		}
	}
    
    func search(text: String?) {
        // To be overridden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = searchBarPlaceHolder
        controller.searchBar.delegate = self
        controller.searchBar.searchTextField.returnKeyType = .done
        self.searchController = controller

        definesPresentationContext = true
        navigationItem.searchController = controller
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = false
        
        controller.searchBar.searchTextField.textPublisher()
            .filter({ $0.unicodeScalars.allSatisfy({CharacterSet.alphanumerics.contains($0)}) })
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .onValue(target: self) { text in
                self.search(text: text)
            }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    override func showLoading(loading: Bool) {
        if loading {
            self.showActivityIndicator()
        } else {
            self.hideActivityIndicator()
        }
    }
	
	func didLoadWithError(error: Error) {
		let searchText = self.searchController?.searchBar.text
		if !searchText.isNilOrEmpty {
			self.showLabel(text: self.errorPlaceholder(searchText))
		} else {
			self.showLabel(text: self.errorPlaceholder(nil))
		}
	}
    
    func didLoad(empty: Bool) {
        if empty {
			let searchText = self.searchController?.searchBar.text
			if !searchText.isNilOrEmpty {
				self.showLabel(text: self.emptyPlaceHolder(searchText))
			} else {
				self.showLabel(text: self.emptyPlaceHolder(nil))
			}
        } else {
            self.hideLabel()
        }
    }
    
}

extension BaseSearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
}

extension BaseSearchViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.search(text: "")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // do nothing on done
    }
}
