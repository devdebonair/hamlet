//
//  AlbumViewController.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/23/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol AlbumViewControllerDelegate: class {
    func didLoad(tableNode: ASTableNode)
    func dataSource() -> [AlbumViewModel]
}

class AlbumViewController: ASViewController<ASTableNode>, ASTableDelegate, ASTableDataSource {
    
    enum CellType: Int {
        case media = 0
        case description = 1
        case separator = 2
        case blank = 3
    }
    
    var delegate: AlbumViewControllerDelegate!
    var dataSource: [AlbumViewModel] { return delegate.dataSource() }
    
    init() {
        super.init(node: ASTableNode(style: .plain))
        node.delegate = self
        node.dataSource = self
    }
    
    override func loadView() {
        super.loadView()
        node.view.separatorStyle = .none
        node.view.backgroundColor = UIColor(red: 247, green: 247, blue: 247)
        delegate.didLoad(tableNode: node)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func numberOfRows(from: AlbumViewModel) -> Int {
        return cellTypes(from: from).count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func cellTypes(from: AlbumViewModel) -> [CellType] {
        var types = [CellType]()
        if let _ = from.media { types.append(.media) }
        if let description = from.description, description.characters.count > 0 { types.append(.description) }
        types.append(.separator)
        types.append(.blank)
        return types
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows(from: dataSource[section])
    }
    
    func tableView(_ tableView: ASTableView, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let albumItem = dataSource[indexPath.section]
        let cellTypes = self.cellTypes(from: albumItem)
        return { _ -> ASCellNode in
            switch cellTypes[indexPath.row] {
                
            case .media:
                if let media = albumItem.media {
                    let mediaSize = CGSize(width: media.width, height: media.height)
                    var cell: ASCellNode!
                    cell = media.type == .photo ? CellNodePhoto(url: nil, size: mediaSize) : CellNodeVideo(url: nil, placeholderURL: nil, size: mediaSize)
                    cell.backgroundColor = .white
                    cell.selectionStyle = .none
                    return cell
                } else {
                    return CellNodeBlank()
                }
                
            case .description:
                var descriptionString = ""
                if let description = albumItem.description { descriptionString = description }
                
                let paragraphStlye = NSMutableParagraphStyle()
                paragraphStlye.lineSpacing = 4
                
                let string = NSAttributedString(
                    string: descriptionString,
                    attributes: [
                        NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular),
                        NSParagraphStyleAttributeName: paragraphStlye])
                
                let cell = CellNodeText(attributedString: string, insets: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
                cell.text.maximumNumberOfLines = 0
                cell.backgroundColor = .white
                cell.selectionStyle = .none
                return cell
            case .separator:
                let cell = CellNodeSeparator(color: UIColor(red: 224, green: 224, blue: 224))
                cell.selectionStyle = .none
                return cell
            case .blank:
                let cell = CellNodeBlank(height: 20)
                cell.selectionStyle = .none
                return cell
            }
        }
    }
    
    func tableView(_ tableView: ASTableView, willDisplayNodeForRowAt indexPath: IndexPath) {
        let albumItem = dataSource[indexPath.section]
        let cell = tableView.nodeForRow(at: indexPath)
        
        if let cell = cell as? CellNodePhoto {
            if let media = albumItem.media {
                cell.photo.url = media.url
            }
        }
        
        if let cell = cell as? CellNodeVideo {
            DispatchQueue.global(qos: .background).async {
                if let media = albumItem.media, let url = media.url {
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
