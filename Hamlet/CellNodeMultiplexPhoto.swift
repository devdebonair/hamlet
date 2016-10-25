//
//  CellNodeMultiplexPhoto.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/23/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CellNodeMultiplexPhoto: ASCellNode, ASMultiplexImageNodeDelegate, ASMultiplexImageNodeDataSource {

    let photo = ASMultiplexImageNode(cache: nil, downloader: ASBasicImageDownloader.shared())
    var size: CGSize
    var urls: [NSString:URL?]
    
    init(urls: [NSString:URL?], size: CGSize) {
        self.size = size
        self.urls = urls
        super.init()
        photo.contentMode = .scaleAspectFill
        photo.clipsToBounds = true
        photo.isLayerBacked = true
        photo.downloadsIntermediateImages = true
        photo.imageIdentifiers = ["large", "medium", "small"].map({ NSString(string: $0) })
        photo.dataSource = self
        photo.delegate = self
        addSubnode(photo)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let height = aspectHeight(constrainedSize.max, size)
        photo.preferredFrameSize = CGSize(width: constrainedSize.max.width, height: height)
        return ASStaticLayoutSpec(children: [photo])
    }
    
    func multiplexImageNode(_ imageNode: ASMultiplexImageNode, urlForImageIdentifier imageIdentifier: ASImageIdentifier) -> URL? {
        let key = imageIdentifier as! NSString
        return urls[key]!
    }
    
}
