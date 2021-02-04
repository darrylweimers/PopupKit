//
//  PanInteractionController.swift
//  CustomPresentation
//
//  Created by Darryl Weimers on 2021-01-24.
//

import UIKit

public final class PanInteractionController: UIPercentDrivenInteractiveTransition {
    
    weak var popupContainerView: UIView?
    let popupDescriptor: PopupDescriptor
    var interactionInProgress = false

    private var shouldCompleteTransition = false
    public weak var popupViewController: UIViewController!

    init(popupViewController: UIViewController, popupDescriptor: PopupDescriptor) {
        self.popupDescriptor = popupDescriptor
        super.init()
        self.popupViewController = popupViewController
        prepareGestureRecognizer(in: popupViewController.view)
    }

    private func prepareGestureRecognizer(in view: UIView) {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        view.addGestureRecognizer(gesture)
    }
    
    private func getProgress(containerView: UIView, popupView: UIView, gestureRecognizer: UIPanGestureRecognizer) -> CGFloat {
        
        // y axis: top of the screen is zero, y translation increments moving from top to bottom
        switch self.popupDescriptor.origin {
        case .top:
            let translation = gestureRecognizer.translation(in: containerView)
            let swipeHeight = popupView.bounds.height + popupDescriptor.pad.top
            var progress = (-translation.y / swipeHeight)   // register swipe up gesture as positive translation to increment progress; swipe up is a negative translation
            //print("y: \(-translation.y)")
            progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
            return progress

        case .bottom:
            let translation = gestureRecognizer.translation(in: containerView)
            let swipeHeight = popupView.bounds.height + popupDescriptor.pad.bottom
            var progress = (translation.y / swipeHeight)
            //print("y: \(translation.y)")
            progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
            return progress

        case .center:
            let translation = gestureRecognizer.translation(in: containerView)
            let swipeHeight = containerView.bounds.height / 2 - popupView.bounds.height / 2 - popupDescriptor.pad.top
            var progress = (translation.y / swipeHeight)
            print("y: \(translation.y)")
            progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
            return progress
        }
    }
    
    @objc func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let popupContainerView = popupContainerView,
              let popupView = gestureRecognizer.view else {
            return
        }
        
        let progress = self.getProgress(containerView: popupContainerView, popupView: popupView, gestureRecognizer: gestureRecognizer)

        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            // trigger view controller to retrieve animation blueprint from animationController(forDismissed dismissed: UIViewController)
            popupViewController.dismiss(animated: true, completion: nil)
            // dismiss keyboard if any
            popupViewController.view.endEditing(true)
            
        case .changed:
            shouldCompleteTransition = progress > 0.5
            update(progress)
            //print("update interaction progress: \(progress)")
            
        case .cancelled:
            interactionInProgress = false
            cancel()
        
        case .ended:
            interactionInProgress = false
            if shouldCompleteTransition {
                finish()
            } else {
                cancel()
            }
            
        default:
        break
        }
    }
}
