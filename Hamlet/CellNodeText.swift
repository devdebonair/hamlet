//
//  CellNodeText.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/22/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CellNodeText: ASCellNode {
    
    var text = ASTextNode()
    private var insets: UIEdgeInsets
    
    init(attributedString: NSAttributedString? = nil, insets: UIEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)) {
        self.insets = insets
        super.init()
        addSubnode(text)
        
        text.isLayerBacked = true
        
        if let attributedString = attributedString {
            text.attributedText = attributedString
            text.maximumNumberOfLines = 4
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: insets, child: text)
    }
}
