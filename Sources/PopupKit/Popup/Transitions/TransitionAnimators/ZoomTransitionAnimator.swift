//
//  ZoomTransitionAnimator.swift
//  CustomPresentation
//
//  Created by Darryl Weimers on 2021-01-27.
//

import UIKit


public final class ZoomTransitionAnimator: TransitionAnimator {
    
    // MARK: - Properties
    let popupDescriptor: PopupDescriptor
    
    // MARK: - Initializers
    init(popupDescriptor: PopupDescriptor, presentationTransition: Transition) {
        self.popupDescriptor = popupDescriptor
        super.init(presentationDuration: 0.6, dismissDuration: 0.2, presentationTransition: presentationTransition)
    }

    // MARK: - UIViewControllerAnimatedTransitioning
    override func willAnimatePresentationTransition(using transitionContext: UIViewControllerContextTransitioning) {
        toView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    }
    
    override func animatingPresentationTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.toView.transform = CGAffineTransform(scaleX: 1, y: 1)
    }
    
    override func willAnimateDimissalTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
    }
    
    override func animatingDimissalTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.fromView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        self.fromView.alpha = 0.0
    }
}
