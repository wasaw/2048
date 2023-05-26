//
//  ScoreView.swift
//  2048
//
//  Created by Александр Меренков on 2/17/22.
//

import UIKit

private enum Constants {
    static let stackDimensions: CGFloat = 10
}

final class ScoreView: UIView {
    
//    MARK: - Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.text = label.text?.uppercased()
        return label
    }()
    
    private lazy var scoreLabel: UILabel = {
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
        stack.anchor(leading: leadingAnchor,
                     top: topAnchor,
                     trailing: trailingAnchor,
                     bottom: bottomAnchor,
                     paddingLeading: Constants.stackDimensions,
                     paddingTop: Constants.stackDimensions,
                     paddingTrailing: -Constants.stackDimensions,
                     paddingBottom: -Constants.stackDimensions)
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func updateScore(_ score: Int) {
        scoreLabel.text = String(score)
    }
}
