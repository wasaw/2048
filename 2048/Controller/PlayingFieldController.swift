//
//  PlayingFieldController.swift
//  2048
//
//  Created by Александр Меренков on 2/11/22.
//

import UIKit

private let reuseIdentifire = "PlayingFieldCell"

class PlayingFieldController: UICollectionViewController {
    
//    MARK: - Properties
    
    private let insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
//    MARK: - Lifecycle
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        view.backgroundColor = .playingBackground
    }
    
//    MARK: - Helpers
    
    func configureUI() {
        configureCollectionView()
    }
    
    func configureCollectionView() {
        collectionView.register(PlayingFieldCell.self, forCellWithReuseIdentifier: reuseIdentifire)
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let sideSquare = CGFloat(view.frame.width - 40)
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 250).isActive = true
        collectionView.widthAnchor.constraint(equalToConstant: sideSquare).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: sideSquare).isActive = true
        collectionView.backgroundColor = .collectionBackground
    }
}

extension PlayingFieldController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifire, for: indexPath) as! PlayingFieldCell
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
}

extension PlayingFieldController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = (collectionView.frame.width - CGFloat(4 * border + 4)) / 5
        let width = collectionView.frame.width / 4 - CGFloat(13)
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insets
    }
}
