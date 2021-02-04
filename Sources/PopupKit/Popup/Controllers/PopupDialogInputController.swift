//
//  PopupDialogInput.swift
//  CustomPresentation
//
//  Created by Darryl Weimers on 2021-01-31.
//
import UIKit

@available(iOS 10.0, *)
open class PopupDialogInputController: PopupController, UITextFieldDelegate {
    
    // MARK: view
    public let dialogView: PopupDialogInputView = PopupDialogInputView()
    
    // MARK: - Initializers
    public init(title: String,
         placeholder: String,
         buttonName: String,
         popupDescriptor: PopupDescriptor = PopupDescriptor(),
         titleColor: UIColor = .black,
         backgroundColor: UIColor = .white) {
        super.init(popupDescriptor: popupDescriptor)
        
        
        dialogView.setupViews(superview: self.view)
        
        /// customize
        view.backgroundColor = backgroundColor
        dialogView.titleLabel.tintColor = titleColor
        
        /// populate content
        dialogView.titleLabel.text = title
        dialogView.textField.placeholder = placeholder
        dialogView.commitButton.setTitle(buttonName, for: .normal)
        
        /// set button target
        dialogView.commitButton.addTarget(self, action: #selector(commitButtonTapped(_:)), for: .primaryActionTriggered)
        
        /// set textField delagate
        dialogView.textField.delegate = self
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
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.dialogView.textField.becomeFirstResponder()
    }
    
    // MARK: - UITextFieldDelegate
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
