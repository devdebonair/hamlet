//
//  AsyncVideoTableViewCell.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/2/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import AsyncDisplayKit
import SnapKit

class AsyncVideoTableViewCell: UITableViewCell {
    
    override class var IDENTIFIER: String {
        return "Video_Table_Cell"
    }

    lazy var videoPlayer: ASVideoNode = {
        let player = ASVideoNode()
        player.gravity = AVLayerVideoGravityResizeAspectFill
        player.shouldAutoplay = true
        player.shouldAutorepeat = true
        return player
    }()
    
    lazy var mainNode: ASDisplayNode = {
        let node = ASDisplayNode()
        return node
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        mainNode.addSubnode(self.videoPlayer)
        contentView.addSubview(self.mainNode.view)
        
        mainNode.view.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.contentView)
            make.height.equalTo(0).priority(750)
        })
        
        videoPlayer.view.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.mainNode.view)
        })
    }
    
    override func prepareForReuse() {
        videoPlayer.asset = nil
    }
    
    func setMediaHeight(height: CGFloat) {
        mainNode.view.snp.makeConstraints { (make) in
            make.height.equalTo(height).priority(750)
        }
    }
    
    func setVideoUrl(url: URL?) {
        guard let url = url else {
            return
        }
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            let asset = AVAsset(url: url)
            self.videoPlayer.asset = asset
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
