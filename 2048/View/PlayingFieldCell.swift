//
//  PlayingFieldCell.swift
//  2048
//
//  Created by Александр Меренков on 2/14/22.
//

import UIKit

class PlayingFieldCell: UICollectionViewCell {
    
//    MARK: - Properties
    let numberLaber: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemGray
        label.textAlignment = .center
        return label
    }()
        
//    MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(numberLaber)
        numberLaber.translatesAutoresizingMaskIntoConstraints = false
        numberLaber.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        numberLaber.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        numberLaber.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        numberLaber.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        
        backgroundColor = .collectionCellBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
