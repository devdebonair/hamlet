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
    func didReachEnd(tableNode: ASTableNode)
}

class FeedViewController: ASViewController<ASTableNode>, ASTableDelegate, ASTableDataSource {
    
    enum CellType: Int {
        case title = 0
        case media = 1
        case flash = 2
        case action = 3
        case upvotes = 4
        case description = 5
        case submission = 6
        case blank = 7
        case separator = 8
    }
    
    var delegate: FeedControllerDelegate!
    var dataSource: [FeedViewModel] { return delegate.dataSource() }
    
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows(from: dataSource[section])
    }
    
    private func numberOfRows(from: FeedViewModel) -> Int {
        // action cell is mandatory
        var count = 0
        if from.media != nil { count += 1 }
        if from.flashColor != nil && from.flashMessage != nil { count += 1 }
        if from.upvotes > 0 { count += 1 }
        if from.description.characters.count > 0 { count += 1 }
        if !from.submission.isEmpty { count += 1 }
        count += 1 // action cell
        count += 1 // blank cell
        count += 1 // title cell
        count += 1 // separator under action
        return count
    }
    
    private func orderOfCells(from: FeedViewModel) -> [CellType] {
        var types = [CellType]()
        types.append(.title)
        if from.media != nil { types.append(.media) } else if from.description.characters.count >= 0 { types.append(.description) }
        if from.flashColor != nil || from.flashMessage != nil { types.append(.flash) }
        types.append(.action)
        types.append(.separator)
        if from.upvotes > 0 { types.append(.upvotes) }
        
        if from.description.characters.count > 0 && !types.contains(.description) { types.append(.description) }
        
        if !from.submission.isEmpty { types.append(.submission) }
        types.append(.blank)
        return types
    }
    
    func tableView(_ tableView: ASTableView, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        
        let feedItem = dataSource[indexPath.section]
        let typeOrder = orderOfCells(from: feedItem)
        
        return { _ -> ASCellNode in
            switch typeOrder[indexPath.row] {
                
            case .title:
                let attributeString = NSAttributedString(
                    string: feedItem.title,
                    attributes: [
                        NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightBold),
                        NSForegroundColorAttributeName: UIColor.darkText
                    ])
                let cell = CellNodeText(attributedString: attributeString, insets: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
                cell.selectionStyle = .none
                return cell
                
            case .media:
                if let media = feedItem.media {
                    let mediaSize = CGSize(width: media.width, height: media.height)
                    var cell: ASCellNode!
                    cell = media.type == .photo ? CellNodePhoto(url: nil, size: mediaSize) : CellNodeVideo(url: nil, placeholderURL: nil, size: mediaSize)
                    cell.selectionStyle = .none
                    return cell
                } else {
                    return CellNodeBlank()
                }
                
            case .flash:
                if let message = feedItem.flashMessage, let color = feedItem.flashColor { return CellNodeFlashMessage(message: message, color: color) }
                else { return CellNodeBlank() }
                
            case .action:
                let cell = CellNodeFeedAction(color: .darkText)
                cell.selectionStyle = .none
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
                
                let text = feedItem.upvotes > 0 ? attributedString : nil
                let cell = CellNodeText(attributedString: text)
                cell.selectionStyle = .none
                return cell
                
            case .description:
                let authorString = NSAttributedString(string: feedItem.author, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightSemibold)])
                let string = NSMutableAttributedString(attributedString: authorString)
                string.append(NSAttributedString(string: " \(feedItem.description)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular)]))
                let cell = CellNodeText(attributedString: string)
                cell.selectionStyle = .none
                return cell
                
            case .submission:
                let cell = CellNodeText(attributedString: NSAttributedString(string: feedItem.submission, attributes: [
                    NSForegroundColorAttributeName: UIColor(red: 164/255, green: 164/255, blue: 164/255, alpha: 1.0),
                    NSFontAttributeName: UIFont.systemFont(ofSize: 12.0)]))
                cell.selectionStyle = .none
                return cell
                
            case .blank:
                let cell = CellNodeBlank(height: 15)
                cell.selectionStyle = .none
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

    func tableView(_ tableView: ASTableView, willDisplayNodeForRowAt indexPath: IndexPath) {
        let feedItem = dataSource[indexPath.section]
        let cell = tableView.nodeForRow(at: indexPath)
        
        if let cell = cell as? CellNodePhoto {
            if let media = feedItem.media {
                cell.photo.url = media.url
            }
        }
        
        if let cell = cell as? CellNodeVideo {
            DispatchQueue.global(qos: .background).async {
                if let media = feedItem.media, let url = media.url {
                    let asset = AVAsset(url: url)
                    DispatchQueue.main.async {
                        cell.videoPlayer.asset = asset
                        cell.videoPlayer.url = media.poster
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: ASTableView, didEndDisplaying node: ASCellNode, forRowAt indexPath: IndexPath) {
        if let node = node as? CellNodeVideo {
            node.videoPlayer.pause()
            node.videoPlayer.asset = nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = node.view.nodeForRow(at: indexPath)
        if let cell = cell as? CellNodeVideo {
            cell.restartVideo()
        }
    }
}
