//
//  CellNodePhoto.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/22/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CellNodePhoto: ASCellNode {
    
    var photo = ASNetworkImageNode()
    var size: CGSize
    var url: URL?
    
    init(url: URL?, size: CGSize) {
        self.size = size
        self.url = url
        super.init()
        photo.contentMode = .scaleAspectFill
        photo.clipsToBounds = true
        photo.url = url
        photo.isLayerBacked = true
        addSubnode(photo)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let height = aspectHeight(constrainedSize.max, size)
        photo.preferredFrameSize = CGSize(width: constrainedSize.max.width, height: height)
        return ASStaticLayoutSpec(children: [photo])
    }

}
