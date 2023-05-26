//
//  LogoView.swift
//  2048
//
//  Created by Александр Меренков on 2/18/22.
//

import UIKit

private enum Constants {
    static let logoDimensions: CGFloat = 10
    static let cornerRadius: CGFloat = 5
}

final class LogoView: UIView {
    
//    MARK: - Properties
    
    private lazy var logoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 38)
        label.textColor = .white
        label.textAlignment = .justified
        label.text = "2048"
        return label
    }()
    
//    MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(logoLabel)
        logoLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        logoLabel.anchor(leading: leadingAnchor,
                         trailing: trailingAnchor,
                         paddingLeading: Constants.logoDimensions,
                         paddingTrailing: -Constants.logoDimensions)
        
        layer.cornerRadius = Constants.cornerRadius
        backgroundColor = UIColor.logoBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
