//
//  PhotoTableViewCell.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/1/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import SnapKit
import AsyncDisplayKit
import PINRemoteImage
import PINCache

class PhotoTableViewCell: UITableViewCell {
    override class var IDENTIFIER: String {
        return "PhotoTableCell"
    }
    
    var imagePhoto: ASNetworkImageNode = {
        let iv = ASNetworkImageNode()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(imagePhoto.view)
        
        imagePhoto.view.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
            make.height.equalTo(0).priority(750)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        imagePhoto.url = nil
        setPhotoHeight(0)
    }
    
    func setPhotoHeight(_ height: CGFloat) {
        imagePhoto.view.snp.updateConstraints { (make) in
            make.height.equalTo(height).priority(750)
        }
    }
}
