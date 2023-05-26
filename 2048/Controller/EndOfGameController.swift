//
//  EndOfGameController.swift
//  2048
//
//  Created by Александр Меренков on 2/18/22.
//

import UIKit

private enum Constants {
    static let endViewPaddingTop: CGFloat = 20
    static let endViewDimensions: CGFloat = 15
    static let endViewHeight: CGFloat = 240
}

final class EndOfGameController: UIViewController {
    
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
        endView.anchor(leading: view.leadingAnchor,
                       top: view.safeAreaLayoutGuide.topAnchor,
                       trailing: view.trailingAnchor,
                       paddingLeading: Constants.endViewDimensions,
                       paddingTop: Constants.endViewPaddingTop,
                       paddingTrailing: -Constants.endViewDimensions,
                       height: Constants.endViewHeight)
        endView.setScore(score)
    }
}

extension EndOfGameController: EndOfGameDelegate {
    func startNewGame() {
        dismiss(animated: true, completion: nil)
    }
}
