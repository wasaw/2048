//
//  ScoreView.swift
//  2048
//
//  Created by Александр Меренков on 2/17/22.
//

import UIKit

class ScoreView: UIView {
    
//    MARK: - Properties
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.text = label.text?.uppercased()
        return label
    }()
    
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 27)
        label.textColor = UIColor.blue
        label.textAlignment = .center
        return label
    }()
    
//    MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: 100).isActive = true
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [nameLabel, scoreLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        stack.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        
        backgroundColor = .collectionCellBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
