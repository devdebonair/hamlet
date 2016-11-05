//
//  CellNodeArticle.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/28/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CellNodeArticle: ASCellNode {

    private let textNodes: [ASTextNode]
    let spacing: CGFloat
    let insets: UIEdgeInsets
    
    init(textArray: [NSAttributedString], spacing: CGFloat, insets: UIEdgeInsets = UIEdgeInsets(top: 15, left: 10, bottom: 10, right: 15)) {
        self.insets = insets
        self.spacing = spacing
        self.textNodes = textArray.map({
            let textNode = ASTextNode()
            textNode.attributedString = $0
            textNode.maximumNumberOfLines = 0
            return textNode
        })
        
        super.init()
        
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stackLayout = ASStackLayoutSpec(direction: .vertical, spacing: spacing, justifyContent: .start, alignItems: .start, children: textNodes)
        return ASInsetLayoutSpec(insets: insets, child: stackLayout)
    }
    
}
