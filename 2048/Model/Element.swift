//
//  Element.swift
//  2048
//
//  Created by Александр Меренков on 2/15/22.
//

import Foundation
import UIKit

enum BackgroundColor: Int, CaseIterable {
    case two
    case four
    case eight
    case sixteen
    case thirtyTwo
    case sixtyFour
    case oneHundredTwentyEight
    case twoHundredFiftySix
    case fiveHundredTwelve
    case oneThousandTwentyFour
    case twoThousandFourtyEight
    
    var color: UIColor {
        switch self {
        case .two: return UIColor.firstChangeColor
        case .four: return UIColor.secondChangeColor
        case .eight: return UIColor.thirdChangeColor
        case .sixteen: return UIColor.fourthChangeColor
        case .thirtyTwo: return UIColor.fifthChangeColor
        case .sixtyFour: return UIColor.sixthChangeColor
        case .oneHundredTwentyEight: return UIColor.seventhChangeColor
        case .twoHundredFiftySix: return UIColor.eighthChangeColor
        case .fiveHundredTwelve: return UIColor.ninthChangeColor
        case .oneThousandTwentyFour: return UIColor.tenthChangeColor
        case .twoThousandFourtyEight: return UIColor.eleventhChangeColor
        }
    }
}

struct Element {
    var x, y: Int
    var number = 2
    var backgroundColor: BackgroundColor = .two
    var isNew = true
    var isTransform = false
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    func toString() -> String {
        return String(number)
    }
    
    func getBackgroundColor() -> UIColor {
        return backgroundColor.color
    }
    
    mutating func toSwipe() {
        number += number
        let backgroundNumber = self.backgroundColor.rawValue + 1
        backgroundColor = BackgroundColor(rawValue: backgroundNumber) ?? .two
    }
}
