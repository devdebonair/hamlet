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

protocol SlideMenuViewControllerDelegate {
    func didBeginSliding()
    func didEndSliding(state: SlideMenuViewController.SlideMenuState)
}

class SlideMenuViewController: ASViewController<ASDisplayNode> {
    
    enum SlideMenuState {
        case menu
        case main
    }
    
    var state: SlideMenuState {
        return nodeMain.view.frame.origin == . zero ? .main : .menu
    }
    
    let main: UIViewController
    let menu: UIViewController
    let nodeMenu: ASDisplayNode
    let nodeMain: ASDisplayNode
    let viewer = UIView()
    let DURATION = 0.1
    let OFFSET: CGFloat = 40
    
    var delegate: SlideMenuViewControllerDelegate!
    
    private let panRecognizer = UIPanGestureRecognizer()
    
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
        
        self.panRecognizer.addTarget(self, action: #selector(self.drag))
        self.delegate = self
        
        node.addSubnode(nodeMenu)
        node.addSubnode(nodeMain)
        
        main.view.frame.origin = .zero
        menu.view.frame.origin = .zero
    }
    
    override func viewDidLoad() {
        nodeMain.view.addGestureRecognizer(panRecognizer)
        nodeMain.isUserInteractionEnabled = true
        menu.view.frame = CGRect(x: 0.0, y: 0.0, width: node.frame.width - OFFSET, height: node.frame.height)
    }
    
    func enableSwipe() {
        panRecognizer.isEnabled = true
    }
    
    func disableSwipe() {
        panRecognizer.isEnabled = false
    }
    
    func openLeftPanel(completion: ((Bool)->Void)? = nil) {
        UIView.animate(withDuration: DURATION, delay: 0.0, options: [.curveEaseIn], animations: {
            self.nodeMain.view.frame.origin.x = self.node.view.frame.width - self.OFFSET
        }, completion: completion)
    }
    
    func closeLeftPanel(completion: ((Bool)->Void)? = nil) {
        UIView.animate(withDuration: DURATION, delay: 0.0, options: [.curveEaseIn], animations: {
            self.nodeMain.view.frame.origin = .zero
        }, completion: completion)
    }
    
    func expandMenu(completion: ((Bool)->Void)? = nil) {
        UIView.animate(withDuration: DURATION, delay: 0.0, options: [.curveEaseIn], animations: {
            self.nodeMain.view.frame.origin.x = self.node.frame.width
            self.nodeMenu.view.frame = CGRect(x: 0.0, y: 0.0, width: self.node.frame.width, height: self.nodeMenu.view.frame.height)
        }, completion: completion)
    }
    
    func contractMenu(completion: ((Bool)->Void)? = nil) {
        UIView.animate(withDuration: DURATION, delay: 0.0, options: [.curveEaseIn], animations: {
            self.nodeMain.view.frame.origin.x = self.node.view.frame.width - self.OFFSET
            self.nodeMenu.frame = CGRect(x: 0.0, y: 0.0, width: self.node.frame.width - self.OFFSET, height: self.nodeMenu.frame.height)
        }, completion: completion)
    }
    
    func drag(sender: UIPanGestureRecognizer) {
        let translationPoint = sender.translation(in: node.view)
        let velocity = sender.velocity(in: node.view)
        let threshhold: CGFloat = 600.0
        
        if nodeMain.view.frame.origin == .zero && translationPoint.x < 0 || nodeMain.view.frame.origin.x == node.view.frame.width - OFFSET && translationPoint.x > 0 { return }
        
        switch sender.state {
        case .began:
            delegate.didBeginSliding()
            break
        case .changed:
            nodeMain.view.frame.origin.x = translationPoint.x > 0 ? translationPoint.x : node.view.frame.width - OFFSET + translationPoint.x
        case .ended:
            if velocity.x > threshhold, translationPoint.x > 0 {
                self.openLeftPanel() { (success) in
                    self.delegate.didEndSliding(state: .menu)
                }
                break
            } else if velocity.x < -threshhold, translationPoint.x < 0 {
                self.closeLeftPanel() { _ in
                    self.delegate.didEndSliding(state: .main)
                }
                break
            }
            
            if translationPoint.x <= node.view.frame.width / 2 {
                self.closeLeftPanel() { _ in
                    self.delegate.didEndSliding(state: .main)
                }
            }
            
            if translationPoint.x >= node.view.frame.width / 2 {
                self.openLeftPanel() { (success) in
                    self.delegate.didEndSliding(state: .menu)
                }
            }
        default:
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SlideMenuViewController: SlideMenuViewControllerDelegate {
    func didBeginSliding() {}
    func didEndSliding(state: SlideMenuViewController.SlideMenuState) {}
}
