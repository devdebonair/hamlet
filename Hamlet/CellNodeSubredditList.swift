//
//  CellNodeCommunityList.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/22/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CellNodeSubredditList: ASCellNode {
    
    let textNode = ASTextNode()
    let imageNode = ASNetworkImageNode()
    let imageHeight: CGFloat
    
    init(subreddit: String? = nil, url: URL? = nil, imageHeight: CGFloat = 40) {
        self.imageHeight = imageHeight
        
        super.init()
        
        addSubnode(textNode)
        addSubnode(imageNode)
        textNode.maximumNumberOfLines = 1
        imageNode.cornerRadius = imageHeight / 2
        imageNode.clipsToBounds = true
        
        if let subreddit = subreddit {
            self.textNode.attributedText = NSAttributedString(string: subreddit, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular)])
        }
        if let url = url { imageNode.url = url }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        imageNode.preferredFrameSize = CGSize(width: imageHeight, height: imageHeight)
        let layout = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 20,
            justifyContent: .start,
            alignItems: .center,
            children: [imageNode, textNode])
        let inset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        return ASInsetLayoutSpec(insets: inset, child: layout)
    }
}
