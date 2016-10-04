//
//  ActionTableViewCell.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/1/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import SnapKit

class ActionTableViewCell: UITableViewCell {

    override class var IDENTIFIER: String {
        return "ActionTableCell"
    }
    
    override var tintColor: UIColor! {
        didSet {
            imageSave.tintColor = tintColor
            imageUp.tintColor = tintColor
            imageDown.tintColor = tintColor
            labelDiscussion.textColor = tintColor
        }
    }
    
    lazy var stackViewIcons: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 20
        sv.alignment = .trailing
        sv.distribution = .fillProportionally
        return sv
    }()
    
    lazy var imageSave: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "save"))
        image.tintColor = self.tintColor
        return image
    }()
    lazy var imageUp: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "arrow-up"))
        image.tintColor = self.tintColor
        return image
    }()
    lazy var imageDown: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "arrow-down"))
        image.tintColor = self.tintColor
        return image
    }()
    
    lazy var labelDiscussion: UILabel = {
        let label = UILabel()
        label.text = "View Discussion"
        label.textColor = self.tintColor
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightBold)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(labelDiscussion)
        contentView.addSubview(stackViewIcons)
        
        stackViewIcons.addArrangedSubview(imageSave)
        stackViewIcons.addArrangedSubview(imageDown)
        stackViewIcons.addArrangedSubview(imageUp)
        
        labelDiscussion.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).inset(15)
            make.top.bottom.equalTo(contentView).inset(18)
            make.right.equalTo(stackViewIcons.snp.left)
        }
        
        stackViewIcons.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).inset(15)
            make.centerY.equalTo(contentView)
        }
        
        let imageHeight = 20
        imageUp.snp.makeConstraints { (make) in
            make.width.height.equalTo(imageHeight)
        }
        imageDown.snp.makeConstraints { (make) in
            make.width.height.equalTo(imageHeight)
        }
        imageSave.snp.makeConstraints { (make) in
            make.width.height.equalTo(imageHeight)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
