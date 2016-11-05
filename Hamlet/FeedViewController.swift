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
    func dataSource() -> [FeedViewModel]
    func didLoad(tableNode: ASTableNode)
    func loadNextPage(completion: @escaping ([FeedViewModel])->Void)
    func didTapFlashMessage(tableNode: ASTableNode, atIndex index: Int)
    func didTapViewDiscussion(tableNode: ASTableNode, atIndex index: Int)
}

class FeedViewController: ASViewController<ASTableNode>, ASTableDelegate, ASTableDataSource {
    
    var delegate: FeedControllerDelegate!
    var dataSource: [FeedViewModel] { return delegate.dataSource() }
    override var prefersStatusBarHidden: Bool { return navigationController?.isNavigationBarHidden ?? false }
    
    init() {
        super.init(node: ASTableNode(style: .plain))
        node.delegate = self
        node.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        node.view.separatorStyle = .none
        node.view.backgroundColor = .white
        delegate.didLoad(tableNode: node)
    }

    override func viewWillDisappear(_ animated: Bool) { navigationController?.interactivePopGestureRecognizer?.delegate = nil }
    func numberOfSections(in tableView: UITableView) -> Int { return dataSource.count }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return numberOfRows(from: dataSource[section]) }
    private func numberOfRows(from: FeedViewModel) -> Int { return from.getNodeTypeOrder().count }
    func shouldBatchFetch(for tableView: ASTableView) -> Bool { return true }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let feedItem = dataSource[indexPath.section]
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
            let feedItem = dataSource[indexPath.section]
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
        if let cell = cell as? CellNodeVideo {
            cell.restartVideo()
        }
        if let _ = cell as? CellNodeFlashMessage {
            delegate.didTapFlashMessage(tableNode: self.node, atIndex: indexPath.section)
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        let beforeFetchCount = numberOfSections(in: tableNode.view)
        delegate.loadNextPage { (items) in
            let lower = beforeFetchCount
            let upper = beforeFetchCount + items.count
            let set = IndexSet(integersIn: lower..<upper)
            tableNode.insertSections(set, with: .fade)
            context.completeBatchFetching(true)
        }
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension  FeedViewController: CellNodeFeedActionDelegate {
    func didTapViewDiscussion(cellNode: CellNodeFeedAction) {
        let indexPath = node.indexPath(for: cellNode)
        if let indexPath = indexPath {
            delegate.didTapViewDiscussion(tableNode: node, atIndex: indexPath.section)
        }
    }
}
