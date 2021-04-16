//
//  PopupFrameManager.swift
//  CustomPresentation
//
//  Created by Darryl Weimers on 2021-01-27.
//

import UIKit

public struct PopupFrameManager {
        
    public static func generateFrame(popupOrigin: PopupOrigin, popupSize: PopupSize, popupView: UIView, inset: UIEdgeInsets = .zero) -> CGRect {
        let size: CGSize = self.getSize(popupSize: popupSize, popupView: popupView, pad: inset)
        let origin: CGPoint = self.getPoint(popupOrigin: popupOrigin, size: size, inset: inset)
        return CGRect(origin: origin, size: size)
    }
    
    private static func getPoint(popupOrigin: PopupOrigin, size: CGSize, inset: UIEdgeInsets) -> CGPoint {
        return CGPoint.generatePoint(presentedLocation: popupOrigin,
                               containerHeight: UIScreen.main.bounds.height,
                               presentedViewHeight: size.height,
                               presentedViewInset: inset)
    }
    
    private static func getSize(popupSize: PopupSize, popupView: UIView, pad: UIEdgeInsets) -> CGSize {
        var size: CGSize = .zero
        
        // retrieve size
        switch popupSize {
       
        case .fullScreen:
            size = CGSize.getSizeRelativeToScreen(width: 1, height: 1)
            break
       
        case .halfOfScreenHeight:
            size = CGSize.getSizeRelativeToScreen(width: 1, height: 0.5)
            break
        
        case .thirdOfScreenHeight:
            size = CGSize.getSizeRelativeToScreen(width: 1, height: 1/3)
            break
            
        case .quarterOfScreenHeight:
            size = CGSize.getSizeRelativeToScreen(width: 1, height: 1/4)
            break
            
        case .minimumRequiredHeight:
            size = CGSize.getSizeWithFittingHeight(view: popupView, andRequiredWidth: UIScreen.main.bounds.width)
            break
        case .fixedHeight(let height):
            size = CGSize(width: UIScreen.main.bounds.width,
                          height: height)
            break
        }
        
        if popupSize == .minimumRequiredHeight {
            size.width = size.width - pad.left - pad.right
        } else {
            size.width = size.width - pad.left - pad.right
            size.height = size.height - pad.top - pad.bottom
        }
        //print("size: \(size)")
        return size
    }

}
