//
//  CellNodeFlashMessage.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/22/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CellNodeFlashMessage: ASCellNode {

    let text = ASTextNode()
    let imageNode = ASImageNode()
    
    init(message: String, color: UIColor) {
        super.init()
        
        addSubnode(text)
        addSubnode(imageNode)
        
        text.attributedText = NSAttributedString(string: message, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightBold), NSForegroundColorAttributeName: UIColor.white])
        imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(.white)
        imageNode.image = #imageLiteral(resourceName: "disclose")
        imageNode.contentMode = .scaleAspectFit
        imageNode.tintColor = .white
        backgroundColor = color
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        imageNode.style.preferredSize = CGSize(width: 15, height: 15)
        text.style.flexGrow = 1.0
        
        let layout = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 5,
            justifyContent: .start,
            alignItems: .center,
            children: [text, imageNode])
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15), child: layout)
        
    }
}
