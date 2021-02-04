//
//  CGPointExtensions.swift
//  CustomPresentation
//
//  Created by Darryl Weimers on 2021-01-26.
//

import UIKit

extension CGPoint {
    
    public static func generatePoint(presentedLocation: PopupOrigin, containerHeight: CGFloat, presentedViewHeight: CGFloat, presentedViewInset: UIEdgeInsets) -> CGPoint {
        
        let x: CGFloat = presentedViewInset.left
        let y: CGFloat =  getYOrigin(presentedLocation: presentedLocation, containerHeight: containerHeight, presentedViewHeight: presentedViewHeight, presentedViewInset: presentedViewInset)
        return CGPoint(x: x, y: y)
    }

    private static func getYOrigin(presentedLocation: PopupOrigin, containerHeight: CGFloat, presentedViewHeight: CGFloat, presentedViewInset: UIEdgeInsets) -> CGFloat {

        switch presentedLocation {
        case .top:
            return presentedViewInset.top

        case .bottom:
            return containerHeight - presentedViewHeight - presentedViewInset.bottom

        case .center:
            return containerHeight / 2 - presentedViewHeight / 2 + presentedViewInset.top
        }
    }
}
    

