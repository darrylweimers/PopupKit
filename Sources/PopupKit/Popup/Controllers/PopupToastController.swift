//
//  PopupToastController.swift
//  CustomPresentation
//
//  Created by Darryl Weimers on 2021-01-24.
//

import UIKit


@available(iOS 10.0, *)
open class PopupToastController: PopupController {
    
    // MARK: views
    public let toastView: PopupToastView = PopupToastView()

    // MARK: init
    public init(title: String,
         popupDescriptor: PopupDescriptor = PopupDescriptor(timeInterval: 2.0),
         titleColor: UIColor = .white,
         backgroundColor: UIColor = .black) {
        
        super.init(popupDescriptor: popupDescriptor)
        
        // customization
        toastView.label.text = title
        toastView.label.textColor = titleColor
        view.backgroundColor = backgroundColor
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setup views
    open override func viewDidLoad() {
        super.viewDidLoad()
        toastView.setupViews(superview: self.view)
    }
}
