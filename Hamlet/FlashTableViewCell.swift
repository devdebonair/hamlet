//
//  FlashTableViewCell.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/3/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import SnapKit

class FlashTableViewCell: UITableViewCell {
    
    override class var IDENTIFIER: String {
        return "Flash_Table_Cell"
    }
    
    var colorProgress: UIColor = .clear {
        didSet {
            viewProgression.backgroundColor = colorProgress
        }
    }
    
    var message: String? {
        didSet {
            labelMessage.text = message
        }
    }

    let viewProgression: UIView = {
        let view = UIView()
        return view
    }()
    
    let labelMessage: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(viewProgression)
        contentView.addSubview(labelMessage)
        
        viewProgression.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(contentView)
            make.right.equalTo(contentView).inset(contentView.frame.width)
            make.height.equalTo(40)
        }
        
        labelMessage.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).inset(15)
            make.centerY.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setProgression(progress: CGFloat) {
        var _progress = progress
        if progress > 1.0, progress < 0.0 { _progress = 0.0 }
        let width = contentView.bounds.width - (contentView.bounds.width * _progress)
        UIView.animate(withDuration: 1.0, delay: 1.0, options: [], animations: {
            self.viewProgression.snp.updateConstraints { (make) in
                make.right.equalTo(self.contentView).inset(width)
            }

            }, completion: nil)
    }
    
    func animateProgress(progress: CGFloat, duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration) { 
            self.setProgression(progress: progress)
        }
    }

}
