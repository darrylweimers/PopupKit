//
//  PopupDialogController.swift
//  CustomPresentation
//
//  Created by Darryl Weimers on 2021-01-24.
//

import UIKit

@available(iOS 10.0, *)
open class PopupDialogController: PopupController {
    
    // MARK: view
    public let dialogView : PopupDialogView = PopupDialogView()
    
    // MARK: - Initializers
    public init(title: String,
         message: String,
         image: UIImage? = nil,
         popupDescriptor: PopupDescriptor = PopupDescriptor(),
         titleColor: UIColor = .white,
         backgroundColor: UIColor = .black) {
        
        super.init(popupDescriptor: popupDescriptor)
        
        /// layout
        dialogView.setupViews(superview: self.view)
        
        /// customize
        view.backgroundColor = backgroundColor
        dialogView.titleLabel.tintColor = titleColor
        
        /// populate content
        dialogView.titleLabel.text = title
        dialogView.messageLabel.text = message
        dialogView.image = image
        
        /// set button target
        dialogView.commitButton.addTarget(self, action: #selector(commitButtonTapped(_:)), for: .primaryActionTriggered)
    }
    
    @objc func commitButtonTapped(_ button: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View setup
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        /// button corner radius
        dialogView.commitButton.layer.cornerRadius = dialogView.commitButton.bounds.height / 2
        dialogView.commitButton.layer.masksToBounds = true
    }
}
