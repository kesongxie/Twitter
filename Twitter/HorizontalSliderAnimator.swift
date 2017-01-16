//
//  HorizontalSliderAnimator.swift
//  Twitter
//
//  Created by Xie kesong on 1/15/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

class HorizontalSliderAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    static let TransitionDuration = 0.3;
    var animatorForDismiss: Bool = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return HorizontalSliderAnimator.TransitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toView = transitionContext.viewController(forKey: .to)?.view else{
            return
        }
        guard let fromView = transitionContext.viewController(forKey: .from)?.view else{
            return
        }
        var  toViewStartFrame = CGRect()
        var  toViewFinalFrame = CGRect()
        var  fromViewFinalFrame = CGRect()

        // Set up the animation parameters.
        if !self.animatorForDismiss {
            // Modify the frame of the presented view so that it starts
            toViewStartFrame = CGRect(x: containerView.frame.size.width, y: 0, width: containerView.frame.size.width, height: containerView.frame.size.height)
            toViewFinalFrame = CGRect(x: 0, y: 0, width:containerView.frame.size.width, height: containerView.frame.size.height)
            containerView.addSubview(toView)
        }else{
            toViewStartFrame = CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: containerView.frame.size.height)
            fromViewFinalFrame = CGRect(x: containerView.frame.size.width, y: 0, width: containerView.frame.size.width, height: containerView.frame.size.height)
            containerView.addSubview(fromView)
        }
        toView.frame = toViewStartFrame;
        UIView.animate(withDuration:  HorizontalSliderAnimator.TransitionDuration, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            if !self.animatorForDismiss{
                toView.frame = toViewFinalFrame
                self.animatorForDismiss = true
            }else{
                fromView.frame = fromViewFinalFrame
                self.animatorForDismiss = false;
            }
        }) { (finished) in
            if finished{
                 transitionContext.completeTransition(true)
            }
        }
    }
    
}
