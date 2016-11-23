//
//  UIViewController+SwipeToDismiss.swift
//  Hamlet
//
//  Created by Vincent Moore on 11/22/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

protocol Swipable {
    func addSwipeToDismiss() -> UIPanGestureRecognizer
    func drag(sender: UIPanGestureRecognizer)
}

extension UIViewController: Swipable {
    
    func addSwipeToDismiss() -> UIPanGestureRecognizer {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(self.drag))
        self.view.addGestureRecognizer(recognizer)
        return recognizer
    }
    
    private func dismiss(completion: ((Bool)->Void)? = nil) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseIn], animations: {
            self.view.frame.origin.x = self.view.frame.width
            self.dismiss(animated: true, completion: nil)
        }, completion: completion)
    }
    
    private func cancel(completion: ((Bool)->Void)? = nil) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseIn], animations: {
            self.view.frame.origin = .zero
            self.dismiss(animated: true, completion: nil)
        }, completion: completion)
    }
    
    
    func drag(sender: UIPanGestureRecognizer) {
        let translationPoint = sender.translation(in: self.view)
        let velocity = sender.velocity(in: self.view)
        let threshhold: CGFloat = 600.0
        
        if self.view.frame.origin == .zero && translationPoint.x < 0 { return }
        
        switch sender.state {
        case .began:
            break
        case .changed:
            self.view.frame.origin.x = translationPoint.x
        case .ended:
            if velocity.x > threshhold, translationPoint.x > 0 {
                self.cancel()
                break
            } else if velocity.x < -threshhold, translationPoint.x < 0 {
                self.dismiss()
                break
            }
            
            if translationPoint.x <= self.view.frame.width / 2 {
                self.cancel()
            }
            
            if translationPoint.x >= self.view.frame.width / 2 {
                self.dismiss()
            }
        default:
            break
        }
    }
}
