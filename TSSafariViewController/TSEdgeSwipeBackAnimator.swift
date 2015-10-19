//
//  TSEdgeSwipeBackAnimator.swift
//  TSSafariViewControllerDemo
//
//  Created by Teng Siong Ong on 10/18/15.
//  Copyright © 2015 Siong Inc. All rights reserved.
//

import UIKit

class TSEdgeSwipeBackAnimator: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {

    var dismissing = false
    var percentageDriven: Bool = false

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.75
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!

        let topView = dismissing ? fromViewController.view : toViewController.view
        let bottomViewController = dismissing ? toViewController : fromViewController
        var bottomView = bottomViewController.view
        let offset = bottomView.bounds.size.width
        if let navVC = bottomViewController as? UINavigationController {
            bottomView = navVC.topViewController?.view
        }

        transitionContext.containerView()?.insertSubview(toViewController.view, aboveSubview: fromViewController.view)
        if dismissing {
            transitionContext.containerView()?.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        }

        topView.frame = fromViewController.view.frame
        topView.transform = dismissing ? CGAffineTransformIdentity : CGAffineTransformMakeTranslation(offset, 0)
        topView.layer.shadowRadius = 5
        topView.layer.shadowOpacity = 0.2

        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1.0, options: TSEdgeSwipeBackAnimator.animOpts(), animations: { () -> Void in
            topView.transform = self.dismissing ? CGAffineTransformMakeTranslation(offset, 0) : CGAffineTransformIdentity
            }) { ( finished ) -> Void in
                topView.transform = CGAffineTransformIdentity
                topView.layer.shadowOpacity = 0.0
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }

    class func animOpts() -> UIViewAnimationOptions {
        return UIViewAnimationOptions.AllowAnimatedContent.union(UIViewAnimationOptions.BeginFromCurrentState).union(UIViewAnimationOptions.LayoutSubviews)
    }

}