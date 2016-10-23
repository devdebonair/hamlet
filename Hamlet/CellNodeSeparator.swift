//
//  CellNodeSeparator.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/22/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CellNodeSeparator: ASCellNode {

    let separator = ASDisplayNode()
    var insets: UIEdgeInsets
    
    init(color: UIColor = .lightGray, insets: UIEdgeInsets = .zero) {
        self.insets = insets
        super.init()
        addSubnode(separator)
        separator.backgroundColor = color
        separator.isLayerBacked = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        separator.preferredFrameSize = CGSize(width: constrainedSize.max.width, height: 1.0)
        return ASInsetLayoutSpec(insets: insets, child: separator)
    }
}
