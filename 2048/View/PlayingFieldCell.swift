//
//  PlayingFieldCell.swift
//  2048
//
//  Created by Александр Меренков on 2/14/22.
//

import UIKit

private enum Constants {
    static let numberLabelDimensions: CGFloat = 5
}

final class PlayingFieldCell: UICollectionViewCell {
    static let reuseIdentifire = "PlayingFieldCell"

//    MARK: - Properties

    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemGray
        label.textAlignment = .center
        return label
    }()
        
//    MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(numberLabel)
        numberLabel.anchor(leading: leadingAnchor,
                           top: topAnchor,
                           trailing: trailingAnchor,
                           bottom: bottomAnchor,
                           paddingLeading: Constants.numberLabelDimensions,
                           paddingTop: Constants.numberLabelDimensions,
                           paddingTrailing: -Constants.numberLabelDimensions,
                           paddingBottom: -Constants.numberLabelDimensions)
        
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
