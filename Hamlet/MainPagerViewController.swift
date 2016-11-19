//
//  MainPageViewController.swift
//  Hamlet
//
//  Created by Vincent Moore on 11/18/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class MainPagerViewController: ASViewController<ASPagerNode>, ASPagerDataSource, ASPagerDelegate {
    
    let main: UIViewController
    let menu: UIViewController
    
    var controllers: [UIViewController] {
        return [menu, main]
    }
    
    init(main: UIViewController, menu: UIViewController) {
        self.main = main
        self.menu = menu
        
        super.init(node: ASPagerNode())
        
        node.setDataSource(self)
        node.setDelegate(self)
    }
    
    func pagerNode(_ pagerNode: ASPagerNode, nodeBlockAt index: Int) -> ASCellNodeBlock {
        let weakSelf = self
        let controller = controllers[index]
        return  { _ -> ASCellNode in
            let node = CellNodePage(viewControllerBlock: { _ -> UIViewController in
                return controller
            })
            if controller == weakSelf.menu { node.multiplier = 0.90 }
            return node
        }
    }
    
    func closeMenu(animated: Bool = false) {
        node.scrollToPage(at: 1, animated: animated)
    }
    
    func openMenu(animated: Bool = false) {
        node.scrollToPage(at: 0, animated: animated)
    }
    
    func numberOfPages(in pagerNode: ASPagerNode) -> Int { return controllers.count }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
