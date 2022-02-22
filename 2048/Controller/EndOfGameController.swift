//
//  EndOfGameController.swift
//  2048
//
//  Created by Александр Меренков on 2/18/22.
//

import UIKit

class EndOfGameController: UIViewController {
    
//    MARK: - Properties
    
    private let score: String
    
    private let endView = EndOfGameView()
    
    init(score: String) {
        self.score = score
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        endView.delegate = self
        
        view.addSubview(endView)
        endView.translatesAutoresizingMaskIntoConstraints = false
        endView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        endView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        endView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        endView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        endView.scoreLabel.text = "Ваш счет: " + score
        
        view.backgroundColor = .playingBackground
    }
}

extension EndOfGameController: EndOfGameDelegate {
    func startNewGame() {
        dismiss(animated: true, completion: nil)
    }
}
