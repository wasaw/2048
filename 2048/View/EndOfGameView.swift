//
//  EndOfGameView.swift
//  2048
//
//  Created by Александр Меренков on 2/18/22.
//

import UIKit

protocol EndOfGameDelegate: AnyObject {
    func startNewGame()
}

class EndOfGameView: UIView {
    
//    MARK: - Properties
    
    private let gameOverLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 47)
        label.textColor = .collectionBorderBackground
        label.text = "Игра окончена!"
        return label
    }()
    
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 38)
        label.textColor = .brown
        return label
    }()
    
    weak var delegate: EndOfGameDelegate?
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Попробовать снова", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize:21)
        button.backgroundColor = .collectionBorderBackground
        button.layer.borderWidth = 1
        button.widthAnchor.constraint(equalToConstant: 250).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
        return button
    }()
    
//    MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        let stack = UIStackView(arrangedSubviews: [gameOverLabel, scoreLabel, backButton])
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .equalSpacing
        stack.alignment = .center
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        stack.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Selectors
    
    @objc func handleButtonTapped() {
        delegate?.startNewGame()
    }
}
