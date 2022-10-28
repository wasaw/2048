//
//  Element.swift
//  2048
//
//  Created by Александр Меренков on 2/15/22.
//

import UIKit

struct Element {
    var x, y: Int
    var number = 2
    var backgroundColor: BackgroundColor = .two
    var fontSize: FontSize = .one
    var isNew = true
    var isTransform = false
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    func getBackgroundColor() -> UIColor {
        return backgroundColor.color
    }
    
    mutating func Collapse() {
        number += number
        let backgroundNumber = self.backgroundColor.rawValue + 1
        backgroundColor = BackgroundColor(rawValue: backgroundNumber) ?? .two
        switch number {
        case 32, 64:
            fontSize = .two
        case 128, 256, 512:
            fontSize = .three
        case 1024, 2048:
            fontSize = .four
        default:
            fontSize = .one
        }
    }
}
