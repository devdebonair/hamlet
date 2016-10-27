//
//  CellNodeCommunityList.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/22/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CellNodeAvatarListItem: ASCellNode {
    
    let textNodeTitle = ASTextNode()
    let textNodeSubtitle = ASTextNode()
    let imageNode = ASNetworkImageNode()
    let imageHeight: CGFloat
    
    init(title: String? = nil, subtitle: String? = nil, url: URL? = nil, imageHeight: CGFloat = 40) {
        self.imageHeight = imageHeight
        
        super.init()
        
        automaticallyManagesSubnodes = true
        
        textNodeTitle.isLayerBacked = true
        textNodeSubtitle.isLayerBacked = true
        imageNode.isLayerBacked = true
        
        textNodeTitle.maximumNumberOfLines = 1
        textNodeSubtitle.maximumNumberOfLines = 1
        
        imageNode.cornerRadius = imageHeight / 2
        imageNode.borderColor = UIColor.lightGray.cgColor
        imageNode.borderWidth = 1.0
        imageNode.clipsToBounds = true
        imageNode.contentMode = .scaleAspectFill
        
        if let subreddit = title {
            self.textNodeTitle.attributedText = NSAttributedString(
                string: subreddit,
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
                ])
        }
        
        if let subText = subtitle {
            self.textNodeSubtitle.attributedText = NSAttributedString(
                string: subText,
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular),
                    NSForegroundColorAttributeName: UIColor.lightGray
                ])
        }
        
        
        if let url = url { imageNode.url = url }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        imageNode.style.preferredSize = CGSize(width: imageHeight, height: imageHeight)
        
        let textStack = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 2,
            justifyContent: .start,
            alignItems: .start,
            children: [textNodeTitle, textNodeSubtitle])
        
        let layout = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 20,
            justifyContent: .start,
            alignItems: .center,
            children: [imageNode, textStack])
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20), child: layout)
    }
}
