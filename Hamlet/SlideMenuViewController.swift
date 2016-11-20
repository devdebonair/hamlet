//
//  DragViewController.swift
//  Hamlet
//
//  Created by Vincent Moore on 11/20/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import UIKit

class SlideMenuViewController: ASViewController<ASDisplayNode> {
    
    let main: UIViewController
    let menu: UIViewController
    let nodeMenu: ASDisplayNode
    let nodeMain: ASDisplayNode
    let viewer = UIView()
    let DURATION = 0.1
    let OFFSET: CGFloat = 40
    
    init(main: ASNavigationController, menu: ASNavigationController) {
        self.main = main
        self.menu = menu
        self.nodeMain = ASDisplayNode(viewBlock: { () -> UIView in
            return main.view
        }, didLoad: nil)
        self.nodeMenu = ASDisplayNode(viewBlock: { () -> UIView in
            return menu.view
        })
        
        super.init(node: ASDisplayNode())
        
        node.addSubnode(nodeMenu)
        node.addSubnode(nodeMain)
        
        main.view.frame.origin = .zero
        menu.view.frame.origin = .zero
    }
    
    override func viewDidLoad() {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.drag))
        nodeMain.view.addGestureRecognizer(panRecognizer)
        nodeMain.isUserInteractionEnabled = true
        nodeMain.view.layer.shadowOpacity = 0.6
        nodeMain.view.layer.shadowOffset = CGSize(width: -2.0, height: 0.0)
        menu.view.frame = CGRect(x: 0.0, y: 0.0, width: node.frame.width - OFFSET, height: node.frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func openLeftPanel(completion: ((Bool)->Void)? = nil) {
        UIView.animate(withDuration: DURATION, delay: 0.0, options: [.curveEaseIn], animations: {
            self.nodeMain.view.frame.origin.x = self.node.view.frame.width - self.OFFSET
        }, completion: nil)
    }
    
    func closeLeftPanel(completion: ((Bool)->Void)? = nil) {
        UIView.animate(withDuration: DURATION, delay: 0.0, options: [.curveEaseIn], animations: {
            self.nodeMain.view.frame.origin = .zero
        }, completion: completion)
    }
    
    func drag(sender: UIPanGestureRecognizer) {
        let translationPoint = sender.translation(in: node.view)
        let velocity = sender.velocity(in: node.view)
        let threshhold: CGFloat = 600.0
        
        if nodeMain.view.frame.origin == .zero && translationPoint.x < 0 || nodeMain.view.frame.origin.x == node.view.frame.width - OFFSET && translationPoint.x > 0 { return }
        
        switch sender.state {
        case .began:
            break
        case .changed:
            nodeMain.view.frame.origin.x = translationPoint.x > 0 ? translationPoint.x : node.view.frame.width - OFFSET + translationPoint.x
        case .ended:
            if velocity.x > threshhold, translationPoint.x > 0 {
                self.openLeftPanel()
                break
            } else if velocity.x < -threshhold, translationPoint.x < 0 {
                self.closeLeftPanel()
                break
            }
            
            if translationPoint.x <= node.view.frame.width / 2 {
                self.closeLeftPanel()
            }
            
            if translationPoint.x >= node.view.frame.width / 2 {
                self.openLeftPanel()
            }
        default:
            break
        }
    }
    
}
