//
//  SubredditListViewController.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/22/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol SubredditListDelegate: class {
    func dataSource() -> [SubredditListViewModel]
    func didLoad(tableNode: ASTableNode)
    func didSelectItem(tableNode: ASTableNode, row: Int)
    func didSearch(tableNode: ASTableNode, text: String)
    func didCancelSearch(tableNode: ASTableNode)
    func didTapSearch()
    func searchClear()
}

class SubredditListViewController: ASViewController<ASTableNode>, ASTableDelegate, ASTableDataSource {
    
    override var prefersStatusBarHidden: Bool {
        return navigationController?.isNavigationBarHidden ?? false
    }
    
    var delegate: SubredditListDelegate!
    var dataSource: [SubredditListViewModel] { return delegate.dataSource() }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    init() {
        super.init(node: ASTableNode(style: .plain))
        node.delegate = self
        node.dataSource = self
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.titleView = searchController.searchBar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self

        searchController.searchBar.sizeToFit()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Subreddits"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchBar.delegate = self
        
        navigationItem.titleView = searchController.searchBar
        
        node.view.separatorStyle = .none
        node.view.backgroundColor = .white
        delegate.didLoad(tableNode: node)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { return dataSource.count }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.didSelectItem(tableNode: node, row: indexPath.section)
    }
    
    func tableView(_ tableView: ASTableView, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let item = dataSource[indexPath.section]
        return { _ -> ASCellNode in
            let cell = CellNodeAvatarListItem(title: item.title, subtitle: item.subtitle.lowercased(), url: item.imageURL)
            cell.backgroundColor = .white
            return cell
        }
    }
    
    func scrollToTop(animated: Bool = false) {
        guard !dataSource.isEmpty else { return }
        node.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: animated)
    }
}

extension SubredditListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {}
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        delegate.didCancelSearch(tableNode: self.node)
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchController.searchBar.text, text.characters.count > 0, !text.isEmpty else {
            return delegate.didCancelSearch(tableNode: self.node)
        }
        delegate.didSearch(tableNode: self.node, text: text)
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.characters.count > 0 else {
            return delegate.searchClear()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        delegate.didTapSearch()
    }
}

extension SubredditListViewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.endEditing(true)
    }
}
