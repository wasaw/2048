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
    
    private let insets = UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 10)
    private var elements: [Element] = []
    
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
        configureSwipeGestureRecognizer()
        
        start()
        
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
        collectionView.heightAnchor.constraint(equalToConstant: sideSquare + 15).isActive = true
        collectionView.backgroundColor = .collectionBorderBackground
    }
    
    func configureSwipeGestureRecognizer() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        collectionView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        collectionView.addGestureRecognizer(swipeRight)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeUp))
        swipeUp.direction = .up
        collectionView.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
        swipeDown.direction = .down
        collectionView.addGestureRecognizer(swipeDown)
    }
    
    func start() {
        let element = Element(randome(), randome())
        elements.append(element)
    }
    
    func addElement() {
        let isNotAdded = true
        var isNotMatch = true
        var element = Element(0, 0)
        while isNotAdded == isNotMatch {
            element = Element(randome(), randome())
            isNotMatch = false
            for item in elements {
                if item.x == element.x && item.y == element.y {
                    isNotMatch.toggle()
                }
            }
        }
        elements.append(element)
        collectionView.reloadData()
    }
    
    func randome() -> Int {
        return Int.random(in: 0...3)
    }
    
//    MARK: - Selectors
    
    @objc func handleSwipeLeft() {
        print("DEBUG: Swipe left")
        var tempElements: [Element] = []
        
        for i in 0...3 {
            var yElements: [Element] = []
            for item in elements {
                if item.y == i {
                    yElements.append(item)
                }
            }
            if yElements.isEmpty { continue }
            if yElements.count == 1 {
                yElements[0].x = 0
                tempElements += yElements
            } else {
                for j in 1..<yElements.count {
                    if yElements[j-1].number == yElements[j].number {
                        yElements[j-1].toSwipe()
                        yElements[j].number = 0
                    }
                }
                yElements.removeAll {$0.number == 0}
                for j in 0..<yElements.count {
                    yElements[j].x = j
                }
                tempElements += yElements
            }
        }
        elements = tempElements
        addElement()
    }
    
    @objc func handleSwipeRight() {
        print("DEBUG: Swipe right")
        
        var tempElements: [Element] = []
        
        for i in 0...3 {
            var yElements: [Element] = []
            for item in elements {
                if item.y == i {
                    yElements.append(item)
                }
            }
            if yElements.isEmpty { continue }
            if yElements.count == 1 {
                yElements[0].x = 3
                tempElements += yElements
            } else {
                yElements = yElements.sorted(by: { $0.x > $1.x })
                for j in 1..<yElements.count {
                    if yElements[j-1].number == yElements[j].number {
                        yElements[j-1].toSwipe()
                        yElements[j].number = 0
                    }
                }
                yElements.removeAll {$0.number == 0}
                var index = 3
                for j in 0..<yElements.count {
                    yElements[j].x = index
                    index -= 1
                }
                yElements = yElements.sorted(by: { $0.x < $1.x} )
                tempElements += yElements
            }
        }
        elements = tempElements
        addElement()
        
    }
    
    @objc func handleSwipeUp() {
        print("DEBUG: Swipe up")
        
        var tempElements: [Element] = []
        
        for i in 0...3 {
            var xElements: [Element] = []
            for item in elements {
                if item.x == i {
                    xElements.append(item)
                }
            }
            if xElements.isEmpty { continue }
            if xElements.count == 1 {
                xElements[0].y = 0
                tempElements += xElements
            } else {
                for j in 1..<xElements.count {
                    if xElements[j-1].number == xElements[j].number {
                        xElements[j-1].toSwipe()
                        xElements[j].number = 0
                    }
                }
                xElements.removeAll {$0.number == 0}
                for j in 0..<xElements.count {
                    xElements[j].y = j
                }
                tempElements += xElements
            }
        }
        elements = tempElements
        addElement()
    }
    
    @objc func handleSwipeDown() {
        print("DEBUG: Swipe down")
        
        var tempElements: [Element] = []
        
        for i in 0...3 {
            var xElements: [Element] = []
            for item in elements {
                if item.x == i {
                    xElements.append(item)
                }
            }
            if xElements.isEmpty { continue }
            if xElements.count == 1 {
                xElements[0].y = 3
                tempElements += xElements
            } else {
                for j in 1..<xElements.count {
                    if xElements[j-1].number == xElements[j].number {
                        xElements[j-1].toSwipe()
                        xElements[j].number = 0
                    }
                }
                xElements.removeAll {$0.number == 0}
                var index = 3
                for j in 0..<xElements.count {
                    xElements[j].y = index
                    index -= 1
                }
                tempElements += xElements
            }
        }
        elements = tempElements
        addElement()
    }
}

extension PlayingFieldController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifire, for: indexPath) as! PlayingFieldCell
        cell.numberLaber.text = ""
        cell.backgroundColor = .collectionCellBackground
        for item in elements {
            if item.x == indexPath.row && item.y == indexPath.section {
                cell.numberLaber.text = item.toString()
                cell.backgroundColor = item.getBackgroundColor()
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
}

extension PlayingFieldController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 4 - CGFloat(13)
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insets
    }
}

extension PlayingFieldController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
