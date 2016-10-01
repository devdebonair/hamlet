//
//  PhotoTableViewCell.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/1/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import SnapKit

class PhotoTableViewCell: UITableViewCell {

    override class var IDENTIFIER: String {
        return "PhotoTableCell"
    }
    
    var imagePhoto: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(imagePhoto)
        
        imagePhoto.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setPhotoHeight(_ height: CGFloat) {
        imagePhoto.snp.makeConstraints { (make) in
            make.height.equalTo(height)
        }
    }

}
