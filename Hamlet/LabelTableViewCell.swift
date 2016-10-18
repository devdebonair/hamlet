//
//  LabelTableViewCell.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/1/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import SnapKit

class LabelTableViewCell: UITableViewCell {

    override class var IDENTIFIER: String {
        return "LabelTableCell"
    }
    
    var contentText: String = "" {
        didSet {
            labelContent.text = contentText
        }
    }
    
    var labelContent: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkText
        label.numberOfLines = 4
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(labelContent)
        
        labelContent.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView).inset(15)
            make.top.equalTo(contentView).inset(10)
            make.bottom.equalTo(contentView)
        }
    }
    
    override func prepareForReuse() {
        labelContent.font = UIFont.systemFont(ofSize: 14)
        labelContent.textColor = .darkText
        labelContent.numberOfLines = 4
        contentText = ""
        labelContent.attributedText = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
