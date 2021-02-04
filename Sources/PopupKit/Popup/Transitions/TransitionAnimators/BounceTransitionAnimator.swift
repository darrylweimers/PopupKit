//
//  BounceTransitionAnimator.swift
//  CustomPresentation
//
//  Created by Darryl Weimers on 2021-01-27.
//

import UIKit


public final class BounceTransitionAnimator: TransitionAnimator {
    
    // MARK: - Properties
    let popupDescriptor: PopupDescriptor
    
    // MARK: - Initializers
    init(popupDescriptor: PopupDescriptor, presentationTransition: Transition) {
        self.popupDescriptor = popupDescriptor
        super.init(presentationDuration: 0.6, dismissDuration: 0.2, presentationTransition: presentationTransition)
    }

    // MARK: - UIViewControllerAnimatedTransitioning
    override func willAnimatePresentationTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // slide distance is set to view height
        switch self.popupDescriptor.origin {
        case .top:
            toView.frame.origin.y = -toView.frame.height
            break

        case .bottom:
            toView.frame.origin.y = transitionContext.containerView.frame.size.height
            break

        case .center:
            toView.frame.origin.y = transitionContext.containerView.frame.size.height / 2 -  toView.frame.height
            break
        }
    }
    
    override func animatingPresentationTransition(using transitionContext: UIViewControllerContextTransitioning) {
        toView.frame.origin.y = toViewFinalFrame.origin.y
    }
    
    override func willAnimateDimissalTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
    }
    
    private func getSwipeHeight(using transitionContext: UIViewControllerContextTransitioning) -> CGFloat {
        
        let popupView = fromView
        let containerView = transitionContext.containerView
        
        // y axis: top of the screen is zero, y translation increments moving from top to bottom
        switch self.popupDescriptor.origin {
        case .top:
            let swipeHeight = popupView.bounds.height + popupDescriptor.pad.top
            return -swipeHeight

        case .bottom:
            let swipeHeight = popupView.bounds.height + popupDescriptor.pad.bottom
            return swipeHeight
            
        case .center:
            let swipeHeight = containerView.bounds.height / 2 - popupView.bounds.height / 2 - popupDescriptor.pad.top
            return swipeHeight
        }
    }
    
    override func animatingDimissalTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let swipeHeight = self.getSwipeHeight(using: transitionContext)
        fromView.frame.origin.y = fromView.frame.origin.y + swipeHeight
        fromView.alpha = 0
    }
}
