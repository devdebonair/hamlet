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
}

class FeedViewController: ASViewController<ASTableNode>, ASTableDelegate, ASTableDataSource {
    
    override var prefersStatusBarHidden: Bool {
        return navigationController?.isNavigationBarHidden ?? false
    }
    
    enum CellType: Int {
        case title = 0
        case photo = 1
        case flash = 2
        case action = 3
        case upvotes = 4
        case description = 5
        case submission = 6
        case blank = 7
        case separator = 8
        case mediaDescription = 9
        case video = 10
    }
    
    var delegate: FeedControllerDelegate!
    var dataSource: [FeedViewModel] { return delegate.dataSource() }
    
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows(from: dataSource[section])
    }
    
    private func numberOfRows(from: FeedViewModel) -> Int {
        return orderOfCells(from: from).count
    }
    
    func getNextIndexPaths(from: [FeedViewModel], startSection: Int) -> [IndexPath] {
        var indexPathsToInsert = [IndexPath]()
        for i in 0..<from.count {
            let cellTypesForItem = orderOfCells(from: from[i])
            for j in 0..<cellTypesForItem.count {
                let path = IndexPath(row: j, section: startSection + i)
                indexPathsToInsert.append(path)
            }
        }
        return indexPathsToInsert
    }
    
    private func orderOfCells(from: FeedViewModel) -> [CellType] {
        var types = [CellType]()
        types.append(.title)
        
        if let media = from.media {
            switch media.type {
            case .photo:
                types.append(.photo)
            case .video:
                types.append(.video)
            }
        } else if from.description.characters.count > 0 {
            types.append(.mediaDescription)
        }
        
        if from.flashColor != nil || from.flashMessage != nil { types.append(.flash) }
        types.append(.action)
        types.append(.separator)
        if from.upvotes > 0 { types.append(.upvotes) }
        
        if from.description.characters.count > 0 && !types.contains(.mediaDescription) { types.append(.description) }
        
        if !from.submission.isEmpty { types.append(.submission) }
        types.append(.blank)
        return types
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let feedItem = dataSource[indexPath.section]
        let typeOrder = orderOfCells(from: feedItem)
        
        return { _ -> ASCellNode in
            switch typeOrder[indexPath.row] {
                
            case .title:
                let attributeString = NSAttributedString(
                    string: feedItem.title.htmlDecodedString,
                    attributes: [
                        NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightBold),
                        NSForegroundColorAttributeName: UIColor.darkText
                    ])
                let cell = CellNodeText(attributedString: attributeString, insets: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
                cell.text.maximumNumberOfLines = 0
                cell.selectionStyle = .none
                cell.backgroundColor = .white
                return cell
                
            case .photo:
                if let media = feedItem.media, media.type == .photo {
                    let cell = CellNodePhoto(url: media.url, size: CGSize(width: media.width, height: media.height))
                    cell.selectionStyle = .none
                    return cell
                } else { return CellNodeBlank() }
                
            case .video:
                if let media = feedItem.media, media.type == .video {
                    let cell = CellNodeVideo(url: nil, placeholderURL: media.poster, size: CGSize(width: media.width, height: media.height))
                    cell.selectionStyle = .none
                    return cell
                } else { return CellNodeBlank() }
                
            case .mediaDescription:
                let string = NSAttributedString(
                    string: feedItem.description.htmlDecodedString,
                    attributes: [
                        NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightRegular)])
                let cell = CellNodeText(attributedString: string)
                cell.text.maximumNumberOfLines = 8
                cell.selectionStyle = .none
                cell.backgroundColor = .white
                return cell
                
            case .flash:
                if let message = feedItem.flashMessage, let color = feedItem.flashColor {
                    let cell = CellNodeFlashMessage(message: message, color: color)
                    cell.selectionStyle = .none
                    return cell
                }
                else { return CellNodeBlank() }
                
            case .action:
                let cell = CellNodeFeedAction(color: .darkText)
                cell.selectionStyle = .none
                cell.backgroundColor = .white
                return cell
                
            case .upvotes:
                let attachment = NSTextAttachment()
                attachment.image = #imageLiteral(resourceName: "arrow-up-filled")
                attachment.bounds.size = CGSize(width: 11, height: 11)
                
                let attributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: " "))
                
                let imageAttribute = NSAttributedString(attachment: attachment)
                let upvoteAttribute = NSMutableAttributedString(
                    string: " \(feedItem.upvotes) upvotes",
                    attributes: [
                        NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightSemibold)])
                
                attributedString.append(imageAttribute)
                attributedString.append(upvoteAttribute)
                
                let text: NSMutableAttributedString? = feedItem.upvotes > 0 ? attributedString : nil
                let cell = CellNodeText(attributedString: text, insets: UIEdgeInsets(top: 10, left: 15, bottom: 5, right: 15))
                cell.selectionStyle = .none
                cell.backgroundColor = .white
                return cell
                
            case .description:
                let authorString = NSAttributedString(
                    string: feedItem.author,
                    attributes: [
                        NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightSemibold)])
                let descriptionString = NSAttributedString(
                    string: " \(feedItem.description.htmlDecodedString)",
                    attributes: [
                        NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular)])
                
                let description = NSMutableAttributedString(attributedString: authorString)
                description.append(descriptionString)
                
                let cell = CellNodeText(attributedString: description)
                cell.selectionStyle = .none
                cell.backgroundColor = .white
                return cell
                
            case .submission:
                let cell = CellNodeText(attributedString: NSAttributedString(string: feedItem.submission, attributes: [
                    NSForegroundColorAttributeName: UIColor(red: 164, green: 164, blue: 164),
                    NSFontAttributeName: UIFont.systemFont(ofSize: 12.0)]))
                cell.selectionStyle = .none
                cell.backgroundColor = .white
                return cell
                
            case .blank:
                let cell = CellNodeBlank(height: 15)
                cell.selectionStyle = .none
                cell.backgroundColor = .white
                return cell
                
            case .separator:
                let color = UIColor(red: 0.783922, green: 0.780392, blue: 0.8, alpha: 1.0)
                let inset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
                let cell = CellNodeSeparator(color: color, insets: inset)
                cell.selectionStyle = .none
                return cell
            }
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
    
    func shouldBatchFetch(for tableView: ASTableView) -> Bool {
        return true
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
