//
//  PlayingFieldCell.swift
//  2048
//
//  Created by Александр Меренков on 2/14/22.
//

import UIKit

class PlayingFieldCell: UICollectionViewCell {
    
//    MARK: - Properties
    
//    MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .collectionCellBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
