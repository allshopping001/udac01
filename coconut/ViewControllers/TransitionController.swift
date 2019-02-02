//
//  TransitionController.swift
//  coconut
//
//  Created by macos on 30/01/19.
//  Copyright © 2019 macos. All rights reserved.
//

import UIKit

class TransitionController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to)
            else {return}
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            toVC.view.subviews[0].transform = CGAffineTransform(translationX: 145, y: 0)
            toVC.view.subviews[1].transform = CGAffineTransform(translationX: 145, y: 0)

        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

class ReverseTransitionController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) else {return}
        //let containerView = transitionContext.containerView
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
            fromVC.view.subviews[0].transform = CGAffineTransform(translationX: -145, y: 0)
            fromVC.view.subviews[1].transform = CGAffineTransform(translationX: -144, y: 0)

        }, completion: { _ in
            fromVC.view.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

class TransitionController_2: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to)
            else {return}
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            toVC.view.subviews[0].transform = CGAffineTransform(translationX: -375, y: 0)
            //toVC.view.subviews[1].transform = CGAffineTransform(translationX: 120, y: 0)
            
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

