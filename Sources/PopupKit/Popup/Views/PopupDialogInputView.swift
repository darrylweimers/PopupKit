//
//  PopupDialogInputView.swift
//  CustomPresentation
//
//  Created by Darryl Weimers on 2021-01-31.
//

import UIKit

open class PopupDialogInputView : UIView {
    
    public lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(white: 0.4, alpha: 1)
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        return titleLabel
    }()
    
    public lazy var textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.textColor = UIColor(white: 0.6, alpha: 1)
        textField.font = UIFont.preferredFont(forTextStyle: .title1)
        return textField
    }()
    
    
    public lazy var commitButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        button.setTitle("Got it", for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 32, bottom: 8, right: 32)
        button.backgroundColor = .systemBlue
        return button
    }()
    
    public lazy var rootStackView: UIStackView = {
        let views =  [titleLabel, textField, commitButton]
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 30
        return stackView
    }()
    
    public func setupViews(superview: UIView) {
        // Add views
        superview.addSubview(rootStackView)
        
        let verticalInset: CGFloat = 20
        let horizontalInset: CGFloat = 30
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: superview.topAnchor, constant: verticalInset),
            rootStackView.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -verticalInset),
            rootStackView.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: horizontalInset),
            rootStackView.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -horizontalInset),
        ])

    }
}

