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
    
    weak var delegate: EndOfGameDelegate?
    
    private let gameOverLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 47)
        label.textColor = .collectionBorderBackground
        label.text = "Игра окончена!"
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 38)
        label.textColor = .brown
        return label
    }()
        
    private let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Попробовать снова", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize:21)
        button.backgroundColor = .collectionBorderBackground
        button.layer.borderWidth = 1
        button.anchor(width: 250, height: 60)
        button.layer.cornerRadius = 5
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
        stack.anchor(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: bottomAnchor, paddingLeft: 10, paddingTop: 10, paddingRight: -10, paddingBottom: -10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Helpers
    
    func setScore(_ score: Int) {
        scoreLabel.text = "Ваш счет: " + String(score)
    }
    
//    MARK: - Selectors
    
    @objc private func handleButtonTapped() {
        delegate?.startNewGame()
    }
}
