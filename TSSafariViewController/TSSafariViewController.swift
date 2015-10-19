//
//  TSSafariViewController.swift
//  TSSafariViewControllerDemo
//
//  Created by Teng Siong Ong on 10/18/15.
//  Copyright © 2015 Siong Inc. All rights reserved.
//

import UIKit
import SafariServices

protocol TSSafariViewControllerDelegate {
    func safariViewController(controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool)
    func safariViewController(controller: SFSafariViewController, activityItemsForURL URL: NSURL, title: String?) -> [UIActivity]
    func safariViewControllerDidFinish(controller: SFSafariViewController)
}

extension TSSafariViewController {

}

public class TSSafariViewController: SFSafariViewController, SFSafariViewControllerDelegate, UIViewControllerTransitioningDelegate {

    var safariDelegate: TSSafariViewControllerDelegate?
    let animator = TSEdgeSwipeBackAnimator()

    var edgeView: UIView? {
        get {
            if (_edgeView == nil && isViewLoaded()) {
                _edgeView = UIView()
                _edgeView?.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(_edgeView!)
                _edgeView?.backgroundColor = UIColor(white: 1.0, alpha: 0.005)

                let bindings = ["edgeView": _edgeView!]
                let options = NSLayoutFormatOptions(rawValue: 0)
                let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|-0-[edgeView(5)]", options: options, metrics: nil, views: bindings)
                let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[edgeView]-0-|", options: options, metrics: nil, views: bindings)
                view?.addConstraints(hConstraints)
                view?.addConstraints(vConstraints)
            }

            return _edgeView
        }
    }

    private var _edgeView: UIView?
    private var _superView: UIView?

    init(URL: NSURL) {
        super.init(URL: URL, entersReaderIfAvailable: false)
        self.initialize()
    }

    override init(URL: NSURL, entersReaderIfAvailable: Bool) {
        super.init(URL: URL, entersReaderIfAvailable: entersReaderIfAvailable)
        self.initialize()
    }

    func initialize() {
        self.delegate = self;
        self.transitioningDelegate = self
    }

    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        let recognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "handleGesture:")
        recognizer.edges = .Left
        self.edgeView?.addGestureRecognizer(recognizer)
    }

    func handleGesture(recognizer:UIScreenEdgePanGestureRecognizer) {
        self.animator.percentageDriven = true
        let percentComplete = recognizer.locationInView(self._superView!).x / self._superView!.bounds.size.width / 2.0
        switch recognizer.state {
        case .Began: dismissViewControllerAnimated(true, completion: nil)
        case .Changed: animator.updateInteractiveTransition(percentComplete > 0.99 ? 0.99 : percentComplete)
        case .Ended, .Cancelled:
            (recognizer.velocityInView(self._superView!).x < 0) ? animator.cancelInteractiveTransition() : animator.finishInteractiveTransition()
            self.animator.percentageDriven = false
        default: ()
        }
    }

    // MARK: - Safari view controller delegate

    public func safariViewControllerDidFinish(controller: SFSafariViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.safariDelegate?.safariViewControllerDidFinish(self)
    }

    public func safariViewController(controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        self.safariDelegate?.safariViewController(self, didCompleteInitialLoad: didLoadSuccessfully)
    }

    public func safariViewController(controller: SFSafariViewController, activityItemsForURL URL: NSURL, title: String?) -> [UIActivity] {
        return (self.safariDelegate?.safariViewController(self, activityItemsForURL: URL, title: title))!
    }

    // MARK: - View controller transition delegate

    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self._superView = presenting.view

        animator.dismissing = false
        return animator
    }

    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.dismissing = true
        return animator
    }

    public func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.animator.percentageDriven ? self.animator : nil
    }

}
