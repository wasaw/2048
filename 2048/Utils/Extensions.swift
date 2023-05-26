//
//  Extensions.swift
//  2048
//
//  Created by Александр Меренков on 2/14/22.
//

import UIKit

//  MARK: - UIColor

extension UIColor {
    static let playingBackground = UIColor(displayP3Red: 246/255, green: 255/255, blue: 248/255, alpha: 1)
    static let collectionBorderBackground = UIColor(displayP3Red: 106/255, green: 101/255, blue: 93/255, alpha: 1)
    static let collectionCellBackground = UIColor(displayP3Red: 222/255, green: 247/255, blue: 254/255, alpha: 1)
    static let logoBackground = UIColor(displayP3Red: 245/255, green: 223/255, blue: 77/255, alpha: 1)
    
    static let firstChangeColor = UIColor(displayP3Red: 255/255, green: 250/255, blue: 221/255, alpha: 1)
    static let secondChangeColor = UIColor(displayP3Red: 253/255, green: 238/255, blue: 217/255, alpha: 1)
    static let thirdChangeColor = UIColor(displayP3Red: 254/255, green: 214/266, blue: 188/255, alpha: 1)
    static let fourthChangeColor = UIColor(displayP3Red: 232/255, green: 197/266, blue: 221/255, alpha: 1)
    static let fifthChangeColor = UIColor(displayP3Red: 227/255, green: 148/266, blue: 165/255, alpha: 1)
    static let sixthChangeColor = UIColor(displayP3Red: 211/255, green: 172/266, blue: 188/255, alpha: 1)
    static let seventhChangeColor = UIColor(displayP3Red: 178/255, green: 222/266, blue: 177/255, alpha: 1)
    static let eighthChangeColor = UIColor(displayP3Red: 179/255, green: 202/266, blue: 232/255, alpha: 1)
    static let ninthChangeColor = UIColor(displayP3Red: 151/255, green: 190/266, blue: 226/255, alpha: 1)
    static let tenthChangeColor = UIColor(displayP3Red: 167/255, green: 217/266, blue: 223/255, alpha: 1)
    static let eleventhChangeColor = UIColor(displayP3Red: 6/255, green: 30/266, blue: 51/255, alpha: 1)
}

//  MARK: - UIView

extension UIView {
    func anchor(leading: NSLayoutXAxisAnchor? = nil,
                top: NSLayoutYAxisAnchor? = nil,
                trailing: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                paddingLeading: CGFloat = 0,
                paddingTop: CGFloat = 0,
                paddingTrailing: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: paddingLeading).isActive = true
        }
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: paddingTrailing).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
