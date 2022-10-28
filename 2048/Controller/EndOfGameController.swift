//
//  EndOfGameController.swift
//  2048
//
//  Created by Александр Меренков on 2/18/22.
//

import UIKit

class EndOfGameController: UIViewController {
    
//    MARK: - Properties
    
    private let score: Int
    private let endView = EndOfGameView()
    
//    MARK: - Lifecycle
    
    init(_ score: Int) {
        self.score = score
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        configureView()
        
        view.backgroundColor = .playingBackground
    }
    
//    MARK: - Helpers
    
    private func configureView() {
        view.addSubview(endView)
        endView.delegate = self
        endView.anchor(left: view.leftAnchor, top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingLeft: 15, paddingTop: 20, paddingRight: -15, height: 240)
        endView.setScore(score)
    }
}

extension EndOfGameController: EndOfGameDelegate {
    func startNewGame() {
        dismiss(animated: true, completion: nil)
    }
}
