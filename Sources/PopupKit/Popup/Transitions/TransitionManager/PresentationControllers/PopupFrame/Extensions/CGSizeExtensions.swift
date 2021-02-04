//
//  Size.swift
//  CustomPresentation
//
//  Created by Darryl Weimers on 2021-01-24.
//

import UIKit

extension CGSize {

    public static func getSizeRelativeToScreen(width relativeWidth: CGFloat, height relativeHeight: CGFloat) -> CGSize {
        
        var widthPercentage = fmaxf(Float(relativeWidth), 0.0)
        widthPercentage = fminf(widthPercentage, 1.0)
        
        var heightPercentage = fmaxf(Float(relativeHeight), 0.0)
        heightPercentage = fminf(heightPercentage, 1.0)
        
        return CGSize(width: UIScreen.main.bounds.width * CGFloat(widthPercentage),
                      height: UIScreen.main.bounds.height * CGFloat(heightPercentage))
    }
    
    public static func getSizeWithFittingHeight(view: UIView, andRequiredWidth width: CGFloat) -> CGSize {
        
        let fittingSize = CGSize(width: width,
                                 height: UIView.layoutFittingCompressedSize.height) // use the smallest possible value
        
        // returns the optizimal size base on current constraint
        return  view.systemLayoutSizeFitting(fittingSize,
                                             withHorizontalFittingPriority: .required,
                                             verticalFittingPriority: .defaultLow)
    }
}

