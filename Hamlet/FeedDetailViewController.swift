//
//  FeedDetailViewController.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/28/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol FeedDetailViewControllerDelegate: class {
    func didLoad(tableNode: ASTableNode)
    func dataSource() -> [FeedDetailViewModel]
    func numberOfRootComments() -> Int
    func numberOfCommentsIn(parent: FeedDetailViewModel) -> Int
    func parentCommentAt(section: Int) -> FeedDetailViewModel
    func commentAt(parent: FeedDetailViewModel, section: Int, index: Int) -> FeedDetailCommentViewModel
    func numberOfParents(parent: FeedDetailViewModel, section: Int, index: Int) -> Int
    func feedItemSubject() -> FeedViewModel
}

class FeedDetailViewController: ASViewController<ASTableNode>, ASTableDelegate, ASTableDataSource {

    enum CellType: Int {
        case commentBlock = 0
        case separator = 1
        case blank = 2
    }
    
    var delegate: FeedDetailViewControllerDelegate!
    var dataSource: [FeedDetailViewModel] { return delegate.dataSource() }
    override var prefersStatusBarHidden: Bool { return navigationController?.isNavigationBarHidden ?? false }
    
    init() {
        super.init(node: ASTableNode(style: .plain))
        node.delegate = self
        node.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        node.view.separatorStyle = .none
        node.view.backgroundColor = .white
        delegate.didLoad(tableNode: node)
    }
    
    override func viewWillDisappear(_ animated: Bool) { navigationController?.interactivePopGestureRecognizer?.delegate = nil }
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return delegate.numberOfRootComments() + 1
    }

    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return delegate.feedItemSubject().getNodeTypeOrder().count }
        return getNodeTypeOrder(from: dataSource[section - 1]).count
    }
    
    func getNodeTypeOrder(from: FeedDetailViewModel) -> [CellType] {
        var types = [CellType]()
        for _ in 0..<delegate.numberOfCommentsIn(parent: from) {
            types.append(.commentBlock)
        }
        types.append(.blank)
        return types
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        
        if indexPath.section == 0 {
            let feedItem = delegate.feedItemSubject()
            return { _ -> ASCellNode in
                let cell = feedItem.getNode(indexPath: indexPath)
                if let cell = cell as? CellNodeText, feedItem.getNodeTypeOrder()[indexPath.row] == .mediaDescription {
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineSpacing = 4.0
                    cell.text.attributedText = NSAttributedString(
                        string: feedItem.description.htmlDecodedString,
                        attributes: [
                            NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightRegular),
                            NSParagraphStyleAttributeName: paragraphStyle
                        ])
                    cell.text.maximumNumberOfLines = 0
                    return cell
                }
                return cell
            }
        }
        
        let parent = delegate.parentCommentAt(section: indexPath.section - 1)
        let cellOrder = getNodeTypeOrder(from: parent)
        
        if indexPath.row == cellOrder.count - 1 {
            return { _ -> ASCellNode in
                let cell = CellNodeBlank(height: 20)
                cell.selectionStyle = .none
                return cell
            }
        }
        
        let comment = delegate.commentAt(parent: parent, section: indexPath.section - 1, index: indexPath.row)
        let numberOfParents = delegate.numberOfParents(parent: parent, section: indexPath.section - 1, index: indexPath.row)
        
        return  { _ -> ASCellNode in
            switch cellOrder[indexPath.row] {
                
            case .commentBlock:
                let paragraph = NSMutableParagraphStyle()
                paragraph.lineSpacing = 2.0
                
                let title = NSAttributedString(
                    string: comment.body.htmlDecodedString,
                    attributes: [
                        NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightRegular),
                        NSParagraphStyleAttributeName: paragraph,
                        NSForegroundColorAttributeName: UIColor.darkText
                    ])
                
                let subTitle = NSAttributedString(
                    string: comment.metaInformation,
                    attributes: [
                        NSFontAttributeName: UIFont.systemFont(ofSize: 10, weight: UIFontWeightRegular),
                        NSForegroundColorAttributeName: UIColor.lightGray
                    ])
                
                let spacing: CGFloat = 15.0 + CGFloat(numberOfParents * 25)
                let cell = CellNodeArticle(textArray: [title, subTitle], spacing: 4, insets: UIEdgeInsets(top: 5, left: spacing, bottom: 5, right: 15))
                cell.backgroundColor = .white
                cell.selectionStyle = .none
                return cell
                
            case .separator:
                let color = UIColor(red: 0.783922, green: 0.780392, blue: 0.8, alpha: 1.0)
                let inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                let cell = CellNodeSeparator(color: color, insets: inset)
                cell.selectionStyle = .none
                return cell
                
            case .blank:
                let cell = CellNodeBlank(height: 20)
                cell.selectionStyle = .none
                return cell
                
            }
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, willDisplayRowWith node: ASCellNode) {
        if let node = node as? CellNodeVideo, node.videoPlayer.asset == nil {
            let media = delegate.feedItemSubject().media
            DispatchQueue.global(qos: .background).async {
                if let media = media, let url = media.url {
                    let asset = AVAsset(url: url)
                    DispatchQueue.main.async {
                        node.videoPlayer.asset = asset
                    }
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
