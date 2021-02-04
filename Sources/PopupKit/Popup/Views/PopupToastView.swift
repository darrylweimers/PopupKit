//
//  ToastView.swift
//  CustomPresentation
//
//  Created by Darryl Weimers on 2021-01-23.
//

import UIKit

open class PopupToastView : UIView {
    
    public lazy var label : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public func setupViews(superview: UIView) {
        superview.addSubview(label)
        let inset: CGFloat = 16
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: superview.topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -inset),
            label.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -inset),
        ])
    }

}
