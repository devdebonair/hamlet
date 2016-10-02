//
//  VideoTableViewCell.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/2/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {
    
    override class var IDENTIFIER: String {
        return "Video_Table_Cell"
    }
    
    internal var videoPlayer = VideoPlayer()
    internal var posterImage = UIImageView()
    
    internal var onReadyToPlay: (()->())? = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        // Keep autolayout from placing constraints
        videoPlayer.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(videoPlayer)
        contentView.addSubview(posterImage)
        
        // Constrain video to bottom of stackview
        videoPlayer.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        posterImage.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        videoPlayer.alpha = 0.0
        posterImage.contentMode = .scaleAspectFit
        
        videoPlayer.onReadyToPlay = {
            UIView.animate(withDuration: 0.5, animations: {
                self.posterImage.alpha = 0.0
                self.videoPlayer.alpha = 1.0
                }, completion: { (success: Bool) in
                    self.posterImage.alpha = 0.0
                    self.videoPlayer.alpha = 1.0
            })
            if let onReadyToPlay = self.onReadyToPlay {
                onReadyToPlay()
            }
        }
    }
    
    func setMediaHeight(_ height: CGFloat) {
        videoPlayer.snp.makeConstraints({ (make) in
            make.height.equalTo(height).priority(750)
        })
        posterImage.snp.makeConstraints { (make) in
            make.height.equalTo(height).priority(750)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Default values
    override func prepareForReuse() {
        super.prepareForReuse()
        videoPlayer.clean()
        videoPlayer.alpha = 0.0
        posterImage.alpha = 1.0
        posterImage.image = nil
    }
    
}
