//
//  CellNodeVideo.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/22/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import NVActivityIndicatorView

class CellNodeVideo: ASCellNode, ASVideoNodeDelegate {

    var videoPlayer = ASVideoNode()
    var size: CGSize
    var spinnerNode: ASDisplayNode
    var asset: AVAsset? = nil
    var placeholderURL: URL? = nil
    
    var spinner: NVActivityIndicatorView {
        return spinnerNode.view as! NVActivityIndicatorView
    }
    
    init(url: URL? = nil, placeholderURL: URL? = nil, size: CGSize) {
        
        spinnerNode = ASDisplayNode(viewBlock: { () -> UIView in
            let rect = CGRect(origin: .zero, size: CGSize(width: 14, height: 14))
            return NVActivityIndicatorView(frame: rect, type: .ballScaleRippleMultiple, color: .white, padding: 0)
        })
        
        self.size = size
        
        super.init()
        
        let weakSelf = self
        if let url = url {
            DispatchQueue.global(qos: .background).async {
                let asset = AVAsset(url: url)
                weakSelf.asset = asset
                DispatchQueue.main.async {
                    weakSelf.videoPlayer.asset = weakSelf.asset
                }
            }
        }
        
        addSubnode(videoPlayer)
        addSubnode(spinnerNode)
        
        videoPlayer.gravity = AVLayerVideoGravityResizeAspectFill
        videoPlayer.shouldAutoplay = true
        videoPlayer.shouldAutorepeat = true
        videoPlayer.placeholderShouldPersist()
        videoPlayer.placeholderEnabled = true
        videoPlayer.placeholderFadeDuration = 2.0
        videoPlayer.backgroundColor = .black
        videoPlayer.muted = true
        videoPlayer.delegate = self
        videoPlayer.isLayerBacked = true
        
        spinnerNode.backgroundColor = .clear
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let height = aspectHeight(constrainedSize.max, size)
        
        videoPlayer.preferredFrameSize = CGSize(width: constrainedSize.max.width, height: height)
        spinnerNode.preferredFrameSize = CGSize(width: 24, height: 24)
        spinnerNode.layoutPosition = CGPoint(x: videoPlayer.preferredFrameSize.width - 40, y: 20)

        let videoLayout = ASStaticLayoutSpec(children: [videoPlayer])
        let spinnerLayout = ASStaticLayoutSpec(children: [spinnerNode])
        
        return ASOverlayLayoutSpec(child: videoLayout, overlay: spinnerLayout)
    }
    
    func videoNode(_ videoNode: ASVideoNode, willChange state: ASVideoNodePlayerState, to toState: ASVideoNodePlayerState) {
        let loadingStates = [ASVideoNodePlayerStateInitialLoading, ASVideoNodePlayerStateLoading, ASVideoNodePlayerStateUnknown]
        
        if loadingStates.contains(state) {
            spinner.startAnimating()
            spinnerNode.isHidden = false
        }
        
        if state == ASVideoNodePlayerStatePlaying {
            spinner.stopAnimating()
            spinnerNode.isHidden = true
        }
    }
    
    func restartVideo() {
        videoPlayer.player?.seek(to: kCMTimeZero)
    }
    
    override func fetchData() {
        super.fetchData()
        videoPlayer.asset = asset
        videoPlayer.url = placeholderURL
    }
    
    override func clearFetchedData() {
        videoPlayer.asset = nil
        super.clearFetchedData()
    }
}
