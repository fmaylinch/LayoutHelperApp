//
//  ViewUtil.swift
//  LayoutHelperApp
//
//  Created by Ferran Maylinch on 18/03/2018.
//  Copyright © 2018 fmaylinch. All rights reserved.
//

import UIKit

class ViewUtil {
    
    // Font

    static let DefaultFontName = "ShareTech-Regular"
    static let SecondFontName = "OpenSans-Light"
    static let FontAwesome = "FontAwesome"

    class func fontMainWithSize(_ size: Float) -> UIFont {
        return font(DefaultFontName, size: size)
    }
    
    class func fontSecondWithSize(_ size: Float) -> UIFont {
        return font(SecondFontName, size: size)
    }
    
    class func fontAwesomeWithSize(_ size: Float) -> UIFont {
        return font(FontAwesome, size: size)
    }
    
    private class func font(_ name: String, size: Float) -> UIFont {
        if let font = UIFont(name: name, size: CGFloat(size)) {
            return font
        } else {
            fatalError("Could not load font `\(name)`")
        }
    }

}
