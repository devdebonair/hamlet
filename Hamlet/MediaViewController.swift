//
//  MediaViewController.swift
//  Hamlet
//
//  Created by Vincent Moore on 11/25/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

protocol MediaViewControllerDelegate {
    func numberOfItems() -> Int
    func dataSource() -> [String]
    func dataAt(key: String) -> MediaViewModel
    func dataFetch(tableNode: ASCollectionNode)
    func dataFetchNext(completion: @escaping ()->Void)
}

class MediaViewController: ASViewController<ASCollectionNode>, UICollectionViewDelegateFlowLayout, ASCollectionDelegate, ASCollectionDataSource {
    
    var delegate: MediaViewControllerDelegate!
    
    init() {
        super.init(node: ASCollectionNode(collectionViewLayout: UICollectionViewFlowLayout()))
        node.delegate = self
        node.dataSource = self
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        node.view.contentInset = UIEdgeInsets(top: 2.0, left: 0.0, bottom: 0.0, right: 0.0)
        delegate.dataFetch(tableNode: node)
    }
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return delegate.numberOfItems()
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let feedItem = delegate.dataAt(key: delegate.dataSource()[indexPath.row])
        return { _ -> ASCellNode in
            let size = CGSize(width: 1.0, height: 1.0)
            if let media = feedItem.media {
                if media.type == .photo {
                    return CellNodePhoto(url: media.url, size: size)
                } else if media.type == .video, let poster = media.poster {
                    return CellNodePhoto(url: poster, size: size)
                }
            }
            let cell = CellNodePhoto(url: nil, size: size)
            cell.photo.backgroundColor = .lightGray
            return cell
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        let nodeWidth = (collectionNode.bounds.width / 3) - 1
        let size = CGSize(width: nodeWidth, height: nodeWidth)
        return ASSizeRange(min: size, max: size)
    }
    
    func close() {
        dismiss(animated: true, completion: nil)
    }
    
    func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
        return true
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
        let beforeFetchCount = delegate.numberOfItems()
        let weakSelf = self
        
        delegate.dataFetchNext {
            let lower = beforeFetchCount
            let upper = beforeFetchCount + (weakSelf.delegate.numberOfItems() - beforeFetchCount)
            var indexes = [IndexPath]()
            for index in lower..<upper {
                let path = IndexPath(row: index, section: 0)
                indexes.append(path)
            }
            collectionNode.insertItems(at: indexes)
            context.completeBatchFetching(true)
        }
    }
}

extension MediaViewController: MediaViewControllerDelegate {
    func dataFetch(tableNode: ASCollectionNode) {}
    func numberOfItems() -> Int { return 0 }
    func dataSource() -> [String] { return [] }
    func dataAt(key: String) -> MediaViewModel { return MediaViewModel(media: Media(url: nil, height: 0, width: 0), primaryKey: "") }
    func dataFetchNext(completion: @escaping ()->Void) {}
}
