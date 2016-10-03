//
//  BlankTableViewCell.swift
//  Hamlet
//
//  Created by Vincent Moore on 10/3/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import SnapKit

class BlankTableViewCell: UITableViewCell {

    override class var IDENTIFIER: String {
        return "Blank_Table_Cell"
    }
    
    private let blankView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(blankView)
        
        blankView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
            make.height.equalTo(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setHeight(height: CGFloat) {
        blankView.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
    }

}
