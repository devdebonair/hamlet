//
//  CellNodeFeedAction.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/22/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CellNodeFeedAction: ASCellNode {

    let buttonSave = ASButtonNode()
    let buttonUpVote = ASButtonNode()
    let buttonDownVote = ASButtonNode()
    let buttonDiscussion = ASButtonNode()
    
    init(color: UIColor = .lightGray) {
        super.init()
        
        buttonSave.setImage(#imageLiteral(resourceName: "save"), for: ASControlState())
        buttonSave.setImage(#imageLiteral(resourceName: "save-filled"), for: .highlighted)
        buttonSave.setImage(#imageLiteral(resourceName: "save-filled"), for: .selected)
        buttonSave.imageNode.contentMode = .scaleAspectFit
        
        buttonUpVote.setImage(#imageLiteral(resourceName: "arrow-up"), for: ASControlState())
        buttonUpVote.setImage(#imageLiteral(resourceName: "arrow-up-filled"), for: .highlighted)
        buttonUpVote.setImage(#imageLiteral(resourceName: "arrow-up-filled"), for: .selected)
        buttonUpVote.imageNode.contentMode = .scaleAspectFit
        
        buttonDownVote.setImage(#imageLiteral(resourceName: "arrow-down"), for: ASControlState())
        buttonDownVote.setImage(#imageLiteral(resourceName: "arrow-down-filled"), for: .highlighted)
        buttonDownVote.setImage(#imageLiteral(resourceName: "arrow-down-filled"), for: .selected)
        buttonDownVote.imageNode.contentMode = .scaleAspectFit
        
        let discussionTitle = NSAttributedString(string: "View Discussion", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightSemibold), NSForegroundColorAttributeName: color])
        buttonDiscussion.setAttributedTitle(discussionTitle, for: ASControlState())
        buttonDiscussion.contentHorizontalAlignment = .horizontalAlignmentLeft
        
        addSubnode(buttonSave)
        addSubnode(buttonUpVote)
        addSubnode(buttonDownVote)
        addSubnode(buttonDiscussion)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let buttonSize = CGSize(width: 20, height: 20)
        
        buttonSave.preferredFrameSize = buttonSize
        buttonUpVote.preferredFrameSize = buttonSize
        buttonDownVote.preferredFrameSize = buttonSize
        
        let buttonSaveStaticLayout = ASStaticLayoutSpec(children: [buttonSave])
        let buttonUpVoteStaticLayout = ASStaticLayoutSpec(children: [buttonUpVote])
        let buttonDownVoteStaticLayout = ASStaticLayoutSpec(children: [buttonDownVote])
        
        buttonDiscussion.flexGrow = true
        
        let rightStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 20,
            justifyContent: .end,
            alignItems: .center,
            children: [buttonSaveStaticLayout, buttonDownVoteStaticLayout, buttonUpVoteStaticLayout])
        
        let buttonStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 5,
            justifyContent: .start,
            alignItems: .center,
            children: [buttonDiscussion, ASStaticLayoutSpec(children: [rightStack])])
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 18, left: 15, bottom: 18, right: 15), child: buttonStack)
    }
}