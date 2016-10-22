//
//  CellNodeVideo.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/22/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CellNodeVideo: ASCellNode, ASVideoNodeDelegate {

    var videoPlayer = ASVideoNode()
    var size: CGSize
    
    init(url: URL?, placeholderURL: URL?, size: CGSize) {
        self.size = size
        
        super.init()
        addSubnode(videoPlayer)
        
        var asset: AVAsset? = nil
        if let url = url { asset = AVAsset(url: url) }
        videoPlayer.asset = asset
        videoPlayer.url = url
        videoPlayer.gravity = AVLayerVideoGravityResizeAspectFill
        videoPlayer.shouldAutoplay = false
        videoPlayer.shouldAutorepeat = true
        videoPlayer.placeholderShouldPersist()
        videoPlayer.placeholderEnabled = true
        videoPlayer.placeholderFadeDuration = 0.5
        videoPlayer.backgroundColor = .black
        videoPlayer.delegate = self
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let height = aspectHeight(constrainedSize.max, size)
        videoPlayer.preferredFrameSize = CGSize(width: constrainedSize.max.width, height: height)
        return ASStaticLayoutSpec(children: [videoPlayer])
    }
    
    func didTap(_ videoNode: ASVideoNode) {
        videoPlayer.player?.seek(to: kCMTimeZero)
    }
}
