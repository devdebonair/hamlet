//
//  VideoView.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/2/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import AVFoundation

class VideoView: UIView {
    fileprivate var _url: String?
    fileprivate var _playerLayer: AVPlayerLayer
    internal var _player: AVPlayer
    
    internal var player: AVPlayer {
        return _player
    }
    
    init(frame: CGRect = CGRect.zero, url: String? = nil) {
        _url = url
        
        if let url = _url, let loadedUrl = URL(string: url) {
            _player = AVPlayer(url: loadedUrl)
        } else {
            _player = AVPlayer()
        }
        
        _playerLayer = AVPlayerLayer(player: _player)
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        super.init(frame: frame)
        
        layer.addSublayer(_playerLayer)
    }
    
    // Not implemented for xibs
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var layerClass : AnyClass {
        return AVPlayerLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _playerLayer.frame = self.bounds
    }
}
