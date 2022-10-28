//
//  PlayingFieldCell.swift
//  2048
//
//  Created by Александр Меренков on 2/14/22.
//

import UIKit

class PlayingFieldCell: UICollectionViewCell {
    
//    MARK: - Properties
    
    static let reuseIdentifire = "PlayingFieldCell"

    private let numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemGray
        label.textAlignment = .center
        return label
    }()
        
//    MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(numberLabel)
        numberLabel.anchor(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: bottomAnchor, paddingLeft: 5, paddingTop: 5, paddingRight: -5, paddingBottom: -5)
        
        layer.cornerRadius = 5
        backgroundColor = .collectionCellBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Helpers
    
    func clear() {
        numberLabel.text = ""
        backgroundColor = .collectionCellBackground
    }
    
    func update(_ element: Element) {
        numberLabel.text = String(element.number)
        numberLabel.font = UIFont.boldSystemFont(ofSize: element.fontSize.rawValue)
        backgroundColor = element.getBackgroundColor()
    }
}
