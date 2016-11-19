//
//  CellNodePage.swift
//  Hamlet
//
//  Created by Vincent Moore on 11/18/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class CellNodePage: ASCellNode {
    var multiplier: CGFloat = 1.0
    override func calculateLayoutThatFits(_ constrainedSize: ASSizeRange) -> ASLayout {
        return ASLayout(layoutElement: self, size: CGSize(width: constrainedSize.max.width * multiplier, height: constrainedSize.max.height))
    }
}
