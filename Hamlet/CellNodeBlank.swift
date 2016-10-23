//
//  CellNodeBlank.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/22/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CellNodeBlank: ASCellNode {
    private let blankNode = ASDisplayNode()
    private var height: CGFloat
    
    init(height: CGFloat = 0) {
        self.height = height
        super.init()
        addSubnode(blankNode)
        blankNode.isLayerBacked = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        blankNode.preferredFrameSize = CGSize(width: constrainedSize.min.width, height: height)
        return ASInsetLayoutSpec(insets: .zero, child: blankNode)
    }
}
