//
//  Model.swift
//  2048
//
//  Created by Александр Меренков on 28.10.2022.
//

import UIKit

enum Direction {
    case left
    case right
    case up
    case down
}

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

enum FontSize: CGFloat {
    case one = 56
    case two = 42
    case three = 30
    case four = 26
}
