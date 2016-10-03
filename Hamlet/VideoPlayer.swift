//
//  VideoView.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/2/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayer: VideoView {
    internal let MAX_VOLUME: Float = 1.0
    internal let MIN_VOLUME: Float = 0.0
    
    internal var autoplay = false
    internal var onReadyToPlay: (()->())?
    
    internal var volume: Float {
        return player.volume
    }
    
    internal var url: String? {
        didSet {
            if let url = url, let loadedUrl = URL(string: url) {
                self.setVideo(loadedUrl)
            }
        }
    }
    
    fileprivate let kStatus = "status"
    
    deinit {
        clean()
    }
    
    init(frame: CGRect = .zero, autoplay: Bool = false) {
        self.autoplay = autoplay
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerItemDidReachEnd(_:)), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clean() {
        player.currentItem?.removeObserver(self, forKeyPath: kStatus)
        player.replaceCurrentItem(with: nil)
        player.volume = 0.0
    }
    
    func playerItemDidReachEnd(_ notification: Notification) {
        player.seek(to: kCMTimeZero)
        player.play()
    }
    
    // Toggle volume
    func toggleVolume() {
        if player.volume > MIN_VOLUME {
            mute()
        } else {
            unmute()
        }
    }
    
    // Decrease volume and fade out accessory view
    func mute() {
        player.volume = MIN_VOLUME
    }
    
    // Increase volume and fade in accessory view
    func unmute() {
        player.volume = MAX_VOLUME
    }
    
    // Pause video and lower opacity of accessory view
    func pause() {
        player.pause()
    }
    
    func play() {
        player.preroll(atRate: 3.0, completionHandler: { (success: Bool) in
            self.mute()
            self.player.play()
        })
    }
    
    // change video in player
    func setVideo(_ url: URL?) {
        if let url = url {
            let asset = AVAsset(url: url)
            asset.loadValuesAsynchronously(forKeys: ["duration", "playable", "tracks"]) {
                let playerItem = AVPlayerItem(asset: asset)
                DispatchQueue.main.async(execute: {
                    if let item = self.player.currentItem {
                        item.removeObserver(self, forKeyPath: self.kStatus)
                    }
                    self.player.replaceCurrentItem(with: playerItem)
                    playerItem.addObserver(self, forKeyPath: self.kStatus, options: [.new], context: nil)
                })
            }
        } else {
            player.replaceCurrentItem(with: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == kStatus, player.currentItem?.status == .readyToPlay else {
            return
        }
        if let readyToPlayClosure = onReadyToPlay {
            readyToPlayClosure()
        }
        if autoplay {
            play()
        }
    }
}
