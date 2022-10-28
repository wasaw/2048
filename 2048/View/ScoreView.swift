//
//  ScoreView.swift
//  2048
//
//  Created by Александр Меренков on 2/17/22.
//

import UIKit

class ScoreView: UIView {
    
//    MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.text = label.text?.uppercased()
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 27)
        label.textColor = UIColor.blue
        label.text = "0"
        label.textAlignment = .center
        return label
    }()
    
//    MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        anchor(width: 100, height: 100)
        configureStack()
        
        layer.cornerRadius = 5
        backgroundColor = .collectionCellBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Helpers
    
    private func configureStack() {
        let stack = UIStackView(arrangedSubviews: [titleLabel, scoreLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        stack.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func updateScore(_ score: Int) {
        scoreLabel.text = String(score)
    }
}
