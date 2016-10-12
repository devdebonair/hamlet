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
    
    enum Vote: Int {
        case up = 0
        case down = 1
        case none
    }
    
    var isSaved: Bool = false {
        didSet { buttonSave.isSelected = isSaved }
    }
    var vote: Vote = .none {
        didSet {
            if vote == .none {
                buttonUpVote.isSelected = false
                buttonDownVote.isSelected = false
            }
            if vote == .up {
                buttonUpVote.isSelected = true
                buttonDownVote.isSelected = false
            }
            if vote == .down {
                buttonUpVote.isSelected = false
                buttonDownVote.isSelected = true
            }
        }
    }

    override class var IDENTIFIER: String {
        return "ActionTableCell"
    }
    
    override var tintColor: UIColor! {
        didSet {
            buttonSave.tintColor = tintColor
            buttonUpVote.tintColor = tintColor
            buttonDownVote.tintColor = tintColor
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
    
    lazy var buttonSave: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "save"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "save-filled"), for: .highlighted)
        button.setImage(#imageLiteral(resourceName: "save-filled"), for: .selected)
        button.tintColor = self.tintColor
        button.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
        return button
    }()
    lazy var buttonUpVote: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "arrow-up"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "arrow-up-filled"), for: .highlighted)
        button.setImage(#imageLiteral(resourceName: "arrow-up-filled"), for: .selected)
        button.tintColor = self.tintColor
        button.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
        return button
    }()
    lazy var buttonDownVote: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "arrow-down"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "arrow-down-filled"), for: .highlighted)
        button.setImage(#imageLiteral(resourceName: "arrow-down-filled"), for: .selected)
        button.tintColor = self.tintColor
        button.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
        return button
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
        
        stackViewIcons.addArrangedSubview(buttonSave)
        stackViewIcons.addArrangedSubview(buttonDownVote)
        stackViewIcons.addArrangedSubview(buttonUpVote)
        
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
        buttonUpVote.snp.makeConstraints { (make) in
            make.width.height.equalTo(imageHeight)
        }
        buttonDownVote.snp.makeConstraints { (make) in
            make.width.height.equalTo(imageHeight)
        }
        buttonSave.snp.makeConstraints { (make) in
            make.width.height.equalTo(imageHeight)
        }
    }
    
    @objc private func savePressed(sender: UIButton) {
        if sender == buttonSave {
            isSaved = !sender.isSelected
        }
        if sender == buttonUpVote {
            if sender.isSelected {
                vote = .none
            } else {
                vote = .up
            }
        }
        if sender == buttonDownVote {
            if sender.isSelected {
                vote = .none
            } else {
                vote = .down
            }
        }
    }
    
    override func prepareForReuse() {
        isSaved = false
        vote = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
