//
//  NewGameButton.swift
//  2048
//
//  Created by Александр Меренков on 2/28/22.
//

import UIKit

protocol NewGameButtonDelegate: AnyObject {
    func startNewGame()
}

final class NewGameButtom: UIButton {
    
//    MARK: - Properties
    weak var delegate: NewGameButtonDelegate?
    
//    MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitle("Новая игра", for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel?.textColor = UIColor.white
        addTarget(self, action: #selector(handleTapped), for: .touchUpInside)
        layer.cornerRadius = 5
        backgroundColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Selectors
    
    @objc private func handleTapped() {
        delegate?.startNewGame()
    }
}
