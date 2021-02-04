//
//  PopupDialogView.swift
//  CustomPresentation
//
//  Created by Darryl Weimers on 2021-01-23.
//

import UIKit

open class PopupDialogView : UIView {
    
    public var imageHeight: CGFloat = 80
    /// The height constraint of the image view, 0 by default
    var imageHeightConstraint: NSLayoutConstraint?
    
    public var image: UIImage? {
        get { return imageView.image}
        set {
            guard let image = newValue else {
                return
            }
            imageView.image = image
            imageHeightConstraint?.isActive = false
            imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: imageHeight)
            imageHeightConstraint?.isActive = true
        }
    }

    // MARK: - Views
    public lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    public lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(white: 0.4, alpha: 1)
        titleLabel.font = .boldSystemFont(ofSize: 14)
        return titleLabel
    }()

    public lazy var messageLabel: UILabel = {
        let messageLabel = UILabel(frame: .zero)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.textColor = UIColor(white: 0.6, alpha: 1)
        messageLabel.font = .systemFont(ofSize: 14)
        return messageLabel
    }()
    
    public lazy var commitButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("Got it", for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.backgroundColor = .systemBlue
        return button
    }()
    
    public lazy var rootStackView: UIStackView = {
        let views =  [imageView, titleLabel, messageLabel, commitButton]
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 10
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

        /// ImageView height constraint
        if image == nil {
            imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 0)
            imageHeightConstraint?.isActive = true
        }
    }
}
