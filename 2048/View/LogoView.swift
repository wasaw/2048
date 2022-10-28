//
//  LogoView.swift
//  2048
//
//  Created by Александр Меренков on 2/18/22.
//

import UIKit

class LogoView: UIView {
    
//    MARK: - Properties
    
    private let logoLabel: UILabel = {
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
        logoLabel.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 10, paddingRight: -10)
        
        layer.cornerRadius = 5
        backgroundColor = UIColor.logoBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
