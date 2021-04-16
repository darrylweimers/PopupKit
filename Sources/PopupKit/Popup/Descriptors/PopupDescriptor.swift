//
//  PopupDescriptor.swift
//  CustomPresentation
//
//  Created by Darryl Weimers on 2021-01-24.
//

import UIKit

public enum Transition {
    case present
    case dismiss
}

public enum TransitionAnimationStyle {
    case bounce
    case zoom
    case fade
}

public enum PopupOrigin {
    case top
    case center
    case bottom
}

public enum PopupSize: Equatable {
    case fullScreen
    case halfOfScreenHeight
    case thirdOfScreenHeight
    case quarterOfScreenHeight
    case minimumRequiredHeight
    case fixedHeight(CGFloat)
}

public struct PopupDescriptor {
   
    // pop up view frame
    public var origin: PopupOrigin
    public var size: PopupSize
    public var pad: UIEdgeInsets
    // popup view layer
    public var roundedCorners: CGFloat?
    // popup self dismiss
    public var timeInterval: TimeInterval?
    // pop up animation
    public var transitionAnimationStyle: TransitionAnimationStyle
    // background view
    public var dimContainerViewWhenPresenting: Bool?
    public var dimViewBackgroundColor: UIColor
    
    public init() {
        self.dimViewBackgroundColor = UIColor(white: 0.0, alpha: 0.5)
        self.transitionAnimationStyle = .bounce
        self.origin = .center
        self.size = .minimumRequiredHeight
        self.pad = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        self.roundedCorners = 8
        dimContainerViewWhenPresenting = true
    }
    
    // Toast
    public init(timeInterval: TimeInterval) {
        self.init()
        self.timeInterval = timeInterval
    }
    
    public func positionPopup(initialPopupViewFrame: CGRect, containerFrame: CGRect) -> CGRect {
        var newPopupViewFrame: CGRect = initialPopupViewFrame
        switch self.origin {
        case .top:
            newPopupViewFrame.origin.y = -initialPopupViewFrame.height
            break

        case .bottom:
            newPopupViewFrame.origin.y = containerFrame.size.height
            break

        case .center:
            newPopupViewFrame.origin.y = containerFrame.size.height / 2 - initialPopupViewFrame.height / 2
            break
        }
        return newPopupViewFrame
    }
    
    @available(iOS 11.0, *)
    public static func top() -> PopupDescriptor {
        let window = UIApplication.shared.windows[0]
        
        var popupDescriptor = PopupDescriptor()
        popupDescriptor.origin = .top
        popupDescriptor.size = .minimumRequiredHeight
        popupDescriptor.pad = UIEdgeInsets(top: window.safeAreaInsets.top, left: 8, bottom: 0, right: 8)
        return popupDescriptor
    }

    public static func center() -> PopupDescriptor {
        var popupDescriptor = PopupDescriptor()
        popupDescriptor.origin = .center
        popupDescriptor.size = .minimumRequiredHeight
        popupDescriptor.pad = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        return popupDescriptor
    }
    @available(iOS 11.0, *)
    public static func bottom() -> PopupDescriptor {
        let window = UIApplication.shared.windows[0]
        
        var popupDescriptor = PopupDescriptor()
        popupDescriptor.origin = .bottom
        popupDescriptor.size = .minimumRequiredHeight
        popupDescriptor.pad = UIEdgeInsets(top: 0, left: 8, bottom: window.safeAreaInsets.bottom, right: 8)
        return popupDescriptor
    }
}


