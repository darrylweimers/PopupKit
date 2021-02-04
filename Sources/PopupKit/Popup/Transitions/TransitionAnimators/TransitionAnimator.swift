//
//  TransitionAnimator.swift
//  CustomPresentation
//
//  Created by Darryl Weimers on 2021-01-23.
//

import Foundation
import UIKit

/// Base class for custom transition animations
public class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var toView: UIView
    var fromView: UIView
    var toViewFinalFrame: CGRect
    var fromViewFinalFrame: CGRect
    let presentationDuration: TimeInterval
    let dismissDuration: TimeInterval
    let presentationTransition: Transition

    init(presentationDuration: TimeInterval, dismissDuration: TimeInterval, presentationTransition: Transition) {
        self.presentationDuration = presentationDuration
        self.dismissDuration = dismissDuration
        self.presentationTransition = presentationTransition
        // default values
        self.toView = UIView()
        self.fromView = UIView()
        self.toViewFinalFrame = CGRect.zero
        self.fromViewFinalFrame = CGRect.zero
        super.init()
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return presentationTransition == .present ? presentationDuration : dismissDuration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // update view and frames
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
            return
        }
        
        // get views
        if let view = transitionContext.view(forKey: .to) {
            toView = view
            //print("to view frame \(toView.frame)")
        }
        if let view = transitionContext.view(forKey: .from) {
            fromView = view
            //print("from view frame \(fromView.frame)")
        }
        
        // update view's frame retrieved
        let toFinalFrame = transitionContext.finalFrame(for: toViewController)
        //print("to final frame \(toFinalFrame)" )
        toViewController.view.frame = toFinalFrame
        toViewFinalFrame = toFinalFrame
        toView.frame = toFinalFrame
        
        let fromFinalFrame = transitionContext.finalFrame(for: fromViewController)
        //print("from final frame \(fromFinalFrame)" )
        fromViewController.view.frame = fromFinalFrame
        fromView.frame = fromFinalFrame
        fromViewFinalFrame = fromFinalFrame
        

        // animation
        switch presentationTransition {
        case .present:
            /// the presented view is `toView`; add it to container before presenting
            transitionContext.containerView.addSubview(toView)
            
            willAnimatePresentationTransition(using: transitionContext)
            UIView.animate(withDuration: presentationDuration, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.curveEaseOut], animations: { [weak self] in
                guard let self = self else { return }
                self.animatingPresentationTransition(using: transitionContext)
            }, completion: { finished in
                transitionContext.completeTransition(finished)
            })
        case .dismiss:
            /// the presented view is `fromView`
            willAnimateDimissalTransition(using: transitionContext)
            UIView.animate(withDuration: dismissDuration, delay: 0.0, options: [.curveEaseIn], animations: { [weak self] in
                guard let self = self else { return }
                self.animatingDimissalTransition(using: transitionContext)
            }, completion: { finished in
                print("animation completed: \(finished)")
                print("transitionWasCancelled: \(transitionContext.transitionWasCancelled)")
                
                if self.presentationTransition == .dismiss &&
                   finished &&
                   !transitionContext.transitionWasCancelled {
                    fromViewController.view.removeFromSuperview()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
    
    // by default use zoom animation
    func willAnimatePresentationTransition(using transitionContext: UIViewControllerContextTransitioning) {
        toView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    }
    
    func animatingPresentationTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.toView.transform = CGAffineTransform(scaleX: 1, y: 1)
    }
    
    func willAnimateDimissalTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
    }
    
    func animatingDimissalTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.fromView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        self.fromView.alpha = 0.0
    }
    
}
