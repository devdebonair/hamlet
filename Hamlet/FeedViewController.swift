//
//  FeedTestViewController.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/22/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol FeedControllerDelegate: class {
    func didLoad(tableNode: ASTableNode)
    func didCancelSearch(tableNode: ASTableNode)
    func didSearch(tableNode: ASTableNode, text: String)
    func didTapFlashMessage(tableNode: ASTableNode, atKey key: String)
    func didTapViewDiscussion(tableNode: ASTableNode, atKey key: String)

    func dataClear()
    func dataFetch(completion: @escaping ()->Void)
    func dataFetchNext(completion: @escaping ()->Void)
    func dataFetchNextSearch(text: String, completion: @escaping ()->Void)
    func dataModel(key: String) -> FeedViewModel
    func dataKeyOrder() -> [String]
    
    func searchClear()
    
    func numberOfModels() -> Int
    
    func willAppear()
    func willDisappear()
}

class FeedViewController: ASViewController<ASTableNode> {
    
    var delegate: FeedControllerDelegate!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    init() {
        super.init(node: ASTableNode(style: .plain))
        node.delegate = self
        node.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let cells = node.visibleNodes
        for cell in cells {
            if let cell = cell as? CellNodeVideo {
                cell.videoPlayer.play()
            }
        }
        delegate.willAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let cells = node.visibleNodes
        for cell in cells {
            if let cell = cell as? CellNodeVideo {
                cell.videoPlayer.pause()
            }
        }
        delegate.willDisappear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = false
        
        searchController.searchBar.sizeToFit()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
        navigationItem.titleView = searchController.searchBar
        
        node.view.separatorStyle = .none
        node.view.backgroundColor = .white
        
        delegate.didLoad(tableNode: node)
    }
    
    func refresh() {
        clear()
        reload()
    }
    
    func reload() {
        delegate.dataFetch {
            self.node.insertSections(IndexSet(integersIn: 0..<self.delegate.numberOfModels()), with: .middle)
        }
        
    }
    
    func clear() {
        let preCount = delegate.numberOfModels()
        delegate.dataClear()
        node.deleteSections(IndexSet(integersIn: 0..<preCount), with: .middle)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension FeedViewController: ASTableDelegate, ASTableDataSource {
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let feedItem = delegate.dataModel(key: delegate.dataKeyOrder()[indexPath.section])
        return { _ -> ASCellNode in
            let cell = feedItem.getNode(indexPath: indexPath)
            if let cell = cell as? CellNodeFeedAction {
                cell.delegate = self
            }
            return cell
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, willDisplayRowWith node: ASCellNode) {
        if let node = node as? CellNodeVideo, let indexPath = tableNode.indexPath(for: node), node.videoPlayer.asset == nil {
            let feedItem = delegate.dataModel(key: delegate.dataKeyOrder()[indexPath.section])
            DispatchQueue.global(qos: .background).async {
                if let media = feedItem.media, let url = media.url {
                    let asset = AVAsset(url: url)
                    DispatchQueue.main.async {
                        node.videoPlayer.asset = asset
                    }
                }
            }
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, didEndDisplayingRowWith node: ASCellNode) {
        if let node = node as? CellNodeVideo {
            node.videoPlayer.pause()
            node.restartVideo()
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        let cell = tableNode.nodeForRow(at: indexPath)
        let key = delegate.dataKeyOrder()[indexPath.section]
        if let cell = cell as? CellNodeVideo {
            cell.restartVideo()
        }
        if let _ = cell as? CellNodeFlashMessage {
            delegate.didTapFlashMessage(tableNode: self.node, atKey: key)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return delegate.numberOfModels()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = delegate.dataModel(key: delegate.dataKeyOrder()[section])
        return numberOfRows(from: item)
    }
    
    private func numberOfRows(from: FeedViewModel) -> Int {
        return from.getNodeTypeOrder().count
    }
    
    func shouldBatchFetch(for tableView: ASTableView) -> Bool {
        return true
    }
    
    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        let beforeFetchCount = numberOfSections(in: tableNode.view)
        let weakSelf = self
        
        if let query = searchController.searchBar.text, !query.isEmpty {
            delegate.dataFetchNextSearch(text: query) { _ in
                let lower = beforeFetchCount
                let upper = beforeFetchCount + (weakSelf.delegate.numberOfModels() - beforeFetchCount)
                let set = IndexSet(integersIn: lower..<upper)
                tableNode.insertSections(set, with: .fade)
                context.completeBatchFetching(true)
            }
        } else {
            delegate.dataFetchNext { _ in
                let lower = beforeFetchCount
                let upper = beforeFetchCount + (weakSelf.delegate.numberOfModels() - beforeFetchCount)
                let set = IndexSet(integersIn: lower..<upper)
                tableNode.insertSections(set, with: .fade)
                context.completeBatchFetching(true)
            }
        }
    }
}

extension FeedViewController: CellNodeFeedActionDelegate {
    func didTapViewDiscussion(cellNode: CellNodeFeedAction) {
        let indexPath = node.indexPath(for: cellNode)
        if let indexPath = indexPath {
            let key = delegate.dataKeyOrder()[indexPath.section]
            delegate.didTapViewDiscussion(tableNode: node, atKey: key)
        }
    }
}

extension FeedViewController: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
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
            return delegate.didCancelSearch(tableNode: node)
        }
    }
}

extension FeedViewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.endEditing(true)
    }
}
