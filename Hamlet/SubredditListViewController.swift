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
    
    override var prefersStatusBarHidden: Bool {
        return navigationController?.isNavigationBarHidden ?? false
    }
    
    var delegate: SubredditListDelegate!
    var dataSource: [SubredditListViewModel] { return delegate.dataSource() }
    
    init() {
        super.init(node: ASTableNode(style: .plain))
        node.delegate = self
        node.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        node.view.separatorStyle = .none
        node.view.backgroundColor = .white
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
            let cell = CellNodeAvatarListItem(title: item.displayName, subtitle: "r/\(item.name)", url: item.imageURL)
            cell.backgroundColor = .white
            return cell
        }
    }
    
}
