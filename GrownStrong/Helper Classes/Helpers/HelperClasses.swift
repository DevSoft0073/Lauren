//
//  HelperClasses.swift
//  Lauren
//
//  Created by Aman on 23/09/21.
//

import UIKit

let height: CGFloat = 44.0;

import UIKit

public enum DisplayType {
    case unknown
    case iphone4
    case iphone5
    case iphone6
    case iphone6plus
    static let iphone7 = iphone6
    static let iphone7plus = iphone6plus
    case iphoneX
    case iphoneXRorXSMAX
}

public final class Display {
    class var width:CGFloat { return UIScreen.main.bounds.size.width }
    class var height:CGFloat { return UIScreen.main.bounds.size.height }
    class var maxLength:CGFloat { return max(width, height) }
    class var minLength:CGFloat { return min(width, height) }
    class var zoomed:Bool { return UIScreen.main.nativeScale >= UIScreen.main.scale }
    class var retina:Bool { return UIScreen.main.scale >= 2.0 }
    class var phone:Bool { return UIDevice.current.userInterfaceIdiom == .phone }
    class var pad:Bool { return UIDevice.current.userInterfaceIdiom == .pad }
    class var carplay:Bool { return UIDevice.current.userInterfaceIdiom == .carPlay }
    class var tv:Bool { return UIDevice.current.userInterfaceIdiom == .tv }
    class var typeIsLike:DisplayType {
        if phone && maxLength < 568 {
            return .iphone4
        }
        else if phone && maxLength == 568 {
            return .iphone5
        }
        else if phone && maxLength == 667 {
            return .iphone6
        }
        else if phone && maxLength == 736 {
            return .iphone6plus
        }
        else if phone && maxLength == 812 {
            return .iphoneX
        }
        else if phone && maxLength == 896 {
            return .iphoneXRorXSMAX
        }
        return .unknown
    }
}

@objc public class TXTabBar: UITabBar {
    
    override public var intrinsicContentSize : CGSize {
        
        var intrinsicSize = super.intrinsicContentSize
        intrinsicSize.height = height

        return intrinsicSize
    }
    
    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = height
        if (Display.typeIsLike == .iphoneX || Display.typeIsLike == .iphoneXRorXSMAX) {
            sizeThatFits.height = height + 35
        }
        
        return sizeThatFits
    }

    @objc var centerButton: UIButton?
    
    override public func point(inside point: CGPoint, with _: UIEvent?) -> Bool {
        if let centerButton = centerButton {
            if centerButton.frame.contains(point) {
                return true
            }
        }
        
        return self.bounds.contains(point)
    }
}
