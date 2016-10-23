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
}

class SubredditListViewController: ASViewController<ASTableNode>, ASTableDelegate, ASTableDataSource {
    
    var delegate: SubredditListDelegate!
    var dataSource: [SubredditListViewModel] { return delegate.dataSource() }
    
    init() {
        super.init(node: ASTableNode(style: .plain))
        node.delegate = self
        node.dataSource = self
    }
    
    override func loadView() {
        super.loadView()
        node.view.separatorStyle = .none
        delegate.didLoad(tableNode: node)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { return dataSource.count }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 1 }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { delegate.didSelectItem(tableNode: node, row: indexPath.section) }
    
    func tableView(_ tableView: ASTableView, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let item = dataSource[indexPath.section]
        return { _ -> ASCellNode in
            let cell = CellNodeSubredditList(subreddit: item.name, url: nil)
            return cell
        }
    }
    
    func tableView(_ tableView: ASTableView, willDisplayNodeForRowAt indexPath: IndexPath) {
        let cell = tableView.nodeForRow(at: indexPath)
        if let cell = cell as? CellNodeSubredditList {
            cell.imageNode.url = dataSource[indexPath.section].imageURL
        }
    }
}
