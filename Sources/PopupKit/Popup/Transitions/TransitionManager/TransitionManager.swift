//
//  TransitionManager.swift
//  CustomPresentation
//
//  Created by Darryl Weimers on 2021-01-24.
//

import UIKit

// View Controller that will be presented
@available(iOS 10.0, *)
public final class TransitionManager: NSObject, UIViewControllerTransitioningDelegate {
    public var dismissInteractionController: PanInteractionController?
    private var popupDescriptor: PopupDescriptor
    
    init(popupDescriptor: PopupDescriptor) {
        self.popupDescriptor = popupDescriptor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewControllerTransitioningDelegate: use custom presentation controller to control transition between presented and presenting controller and set presented view frame, using container frame as a reference
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = PresentationController(presentedViewController: presented,
                                                            presenting: presenting,
                                                            popupDescriptor: popupDescriptor,
                                                            interactionController: dismissInteractionController)
        if let dimContainerViewWhenPresenting = popupDescriptor.dimContainerViewWhenPresenting {
            presentationController.dimContainerViewWhenPresenting = dimContainerViewWhenPresenting
        }
        
        return presentationController
    }
    
    // MARK: Custom present and dismiss animation (presented view appears starting from bottom of the screen if no implemented)
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        // return the dismiss interaction animator
        if let dismissInteractionController = dismissInteractionController {
            if dismissInteractionController.interactionInProgress {
                return BounceTransitionAnimator(popupDescriptor: popupDescriptor, presentationTransition: .dismiss)
            }
        }
        
        switch self.popupDescriptor.transitionAnimationStyle  {
        case .bounce:
            return BounceTransitionAnimator(popupDescriptor: popupDescriptor, presentationTransition: .dismiss)
        case .zoom:
            return ZoomTransitionAnimator(popupDescriptor: popupDescriptor, presentationTransition: .dismiss)
        case .fade:
            return FadeTransitionAnimator(popupDescriptor: popupDescriptor, presentationTransition: .dismiss)
        }
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch self.popupDescriptor.transitionAnimationStyle  {
        case .bounce:
            return BounceTransitionAnimator(popupDescriptor: popupDescriptor, presentationTransition: .present)
        case .zoom:
            return ZoomTransitionAnimator(popupDescriptor: popupDescriptor, presentationTransition: .present)
        case .fade:
            return FadeTransitionAnimator(popupDescriptor: popupDescriptor, presentationTransition: .present)
        }
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let dismissInteractionController = dismissInteractionController else {
            return nil
        }
            
        return dismissInteractionController.interactionInProgress ? dismissInteractionController : nil
    }
}
