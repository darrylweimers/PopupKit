//
//  PresentationController.swift
//  CustomPresentation
//
//  Created by Darryl Weimers on 2021-01-23.
//

import UIKit

@available(iOS 10.0, *)
public final class PresentationController: BasePresentationController {
    
    // MARK: Initialization
    private let popupDescriptor: PopupDescriptor
    private let interactionController: PanInteractionController?
    
    required init(presentedViewController: UIViewController,
                  presenting presentingViewController: UIViewController?,
                  popupDescriptor: PopupDescriptor,
                  interactionController: PanInteractionController?) {
        self.popupDescriptor = popupDescriptor
        self.interactionController = interactionController
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        addObservers()
        setupDimmingView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        fatalError("has not been implemented")
    }
    
    // MARK: dimming view
    private func setupDimmingView() {
        self.dimmingView.backgroundColor = self.popupDescriptor.dimViewBackgroundColor
    }

    // MARK: setup presented frame
    public override var frameOfPresentedViewInContainerView: CGRect {
        
        guard let presentedView = self.presentedView else {
            return .zero
        }
        
        return PopupFrameManager.generateFrame(popupOrigin: self.popupDescriptor.origin,
                                               popupSize: self.popupDescriptor.size,
                                               popupView: presentedView,
                                               inset: self.popupDescriptor.pad)
    }

    // MARK: dismiss presented view controller after timer interval
    public override func presentationTransitionDidEnd(_ completed: Bool) {
        if completed {
            
            guard let timeInterval = self.popupDescriptor.timeInterval else {
                return
            }

            Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { _ in

                self.presentedViewController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    public override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        if let cornerRadius = popupDescriptor.roundedCorners {
            self.presentedView?.layer.cornerRadius = cornerRadius
            self.presentedView?.layer.masksToBounds = true
        }
        
        // supply interactionController with container; this allows the interaction controller to calculate translation progress
        self.interactionController?.popupContainerView = containerView
    }
    
    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            removeObservers()
        }
    }
    
    // MARK: - Keyboard & orientation observers
    private var keyboardHeight: CGFloat?
    private var presentedViewFrameBeforeKeyboardAppeared: CGRect?
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged),
                                                         name: UIDevice.orientationDidChangeNotification,
                                                         object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc fileprivate func keyboardWillShow(_ notification: Notification) {
        presentedViewFrameBeforeKeyboardAppeared = presentedView?.frame
        centerPopup(keyboardWillAppear: true)
    }
    
    @objc fileprivate func keyboardWillHide(_ notification: Notification) {
        centerPopup(keyboardWillAppear: false)
    }

    @objc fileprivate func keyboardWillChangeFrame(_ notification: Notification) {
        guard let keyboardRect = (notification as NSNotification).userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        keyboardHeight = keyboardRect.cgRectValue.height
    }

    @objc fileprivate func orientationChanged(_ notification: Notification) {
        // TODO: implement
    }

    fileprivate func centerPopup(keyboardWillAppear: Bool) {
        guard let keyboardHeight = keyboardHeight,
              let presentedView = presentedView else {
            return
        }

        if keyboardWillAppear {
            let screenHeight = UIScreen.main.bounds.height
            let unoccupiedScreenHeight = screenHeight - keyboardHeight
            presentedView.frame.origin.y = unoccupiedScreenHeight / 2 - presentedView.bounds.height / 2
            
        } else {
            if let presentedViewFrameBeforeKeyboardAppeared = presentedViewFrameBeforeKeyboardAppeared {
                presentedView.frame.origin.y = presentedViewFrameBeforeKeyboardAppeared.origin.y
            }
        }
    }
}

public class BasePresentationController: UIPresentationController {
    // Customizable properties
    public var dimContainerViewWhenPresenting: Bool = false
    
    // MARK: init
    required override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: presentation
    public override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        print("size(forChildContentContainer container: UIContentContainer")
        return .zero
    }
    
    // MARK: dimming view
    public lazy var dimmingView: UIView = {
        let dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 0.0
        let recognizer = UITapGestureRecognizer(
          target: self,
          action: #selector(handleTap(recognizer:)))
        dimmingView.addGestureRecognizer(recognizer)
        return dimmingView
    }()

    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }
    
    private func addDimmingView() {
        guard let containerView = containerView else {
            return
        }
        
        containerView.insertSubview(dimmingView, at: 0)
        NSLayoutConstraint.activate([
            dimmingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

        ])
    }
    
    private func animateDimmingView(animation: Transition) {
        switch animation {
        case .present:
            guard let coordinator = presentedViewController.transitionCoordinator else {
                dimmingView.alpha = 1.0
                return
            }

            coordinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 1.0
            })
        case .dismiss:
            guard let coordinator = presentedViewController.transitionCoordinator else {
                dimmingView.alpha = 0.0
                return
              }

              coordinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 0.0
              })
        }
    }
    
    // Position of the presented view in the container view by the end of the presentation transition.
    public override var frameOfPresentedViewInContainerView: CGRect {
        return .zero
    }
    
    public override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        //print("containerViewWillLayoutSubviews")
    }
    
    public override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        //print("presentationTransitionWillBegin")
        if dimContainerViewWhenPresenting {
            addDimmingView()
            animateDimmingView(animation: .present)
        }
    }
    
    public override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        //print("presentationTransitionDidEnd")
    }

    public override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        //print("dismissalTransitionWillBegin")
        if dimContainerViewWhenPresenting {
            animateDimmingView(animation: .dismiss)
        }
    }

    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        print("dismissalTransitionDidEnd")
    }
    
    public override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        //print("containerViewDidLayoutSubviews")
    }
}
