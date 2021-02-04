//
//  PopupControllerDelegate.swift
//  CustomPresentation
//
//  Created by Darryl Weimers on 2021-01-24.
//

import UIKit

@available(iOS 10.0, *)
open class PopupController: UIViewController {
    
    // MARK: stored properties
    private let transitionManager: TransitionManager
    internal var popupDescriptor: PopupDescriptor
    private lazy var dimissTransitionInteractionController: PanInteractionController = {
        return PanInteractionController(popupViewController: self, popupDescriptor: popupDescriptor)
    }()
    
    // MARK: init
    public init(popupDescriptor: PopupDescriptor) {
        self.popupDescriptor = popupDescriptor
        self.transitionManager = TransitionManager(popupDescriptor: popupDescriptor)
        super.init(nibName: nil, bundle: nil)
        
        /// use custom presentation and handle present and dimiss transition 
        transitioningDelegate = transitionManager
        modalPresentationStyle = .custom
        
        /// popup interactive dismiss
        transitionManager.dismissInteractionController = dimissTransitionInteractionController
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
