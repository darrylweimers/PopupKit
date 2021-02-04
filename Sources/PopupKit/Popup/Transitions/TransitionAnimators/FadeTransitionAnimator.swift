//
//  FadeTransitionAnimator.swift
//  CustomPresentation
//
//  Created by Darryl Weimers on 2021-01-27.
//

import UIKit


public final class FadeTransitionAnimator: TransitionAnimator {
    
    // MARK: - Properties
    let popupDescriptor: PopupDescriptor
    
    // MARK: - Initializers
    init(popupDescriptor: PopupDescriptor, presentationTransition: Transition) {
        self.popupDescriptor = popupDescriptor
        super.init(presentationDuration: 0.6, dismissDuration: 0.2, presentationTransition: presentationTransition)
    }

    // MARK: - UIViewControllerAnimatedTransitioning
    override func willAnimatePresentationTransition(using transitionContext: UIViewControllerContextTransitioning) {
        toView.alpha = 0
    }
    
    override func animatingPresentationTransition(using transitionContext: UIViewControllerContextTransitioning) {
        toView.alpha = 1
    }
    
    override func willAnimateDimissalTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
    }
    
    override func animatingDimissalTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.fromView.alpha = 0.0
    }
}
