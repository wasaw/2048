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
    private var score = 0
    
    private let scoreView = ScoreView()
    private let scoreBestView = ScoreView()
    private let databaseService = DatabaseService()
    private let logoView = LogoView()
    
//    MARK: - Lifecycle
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        start()
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureSwipeGestureRecognizer()
        
        view.backgroundColor = .playingBackground
    }
    
//    MARK: - Helpers
    
    func configureUI() {
        configureCollectionView()
        configureScoreView()
        configureLogo()
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
    
    func configureScoreView() {
        view.addSubview(scoreBestView)
        scoreBestView.translatesAutoresizingMaskIntoConstraints = false
        scoreBestView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        scoreBestView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        scoreBestView.nameLabel.text = "Лучший"
        
        view.addSubview(scoreView)
        scoreView.translatesAutoresizingMaskIntoConstraints = false
        scoreView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        scoreView.rightAnchor.constraint(equalTo: scoreBestView.leftAnchor, constant: -20).isActive = true
        scoreView.nameLabel.text = "Счет"
        scoreView.scoreLabel.text = "0"
    }
    
    func configureLogo() {
        view.addSubview(logoView)
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        logoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        logoView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        logoView.heightAnchor.constraint(equalToConstant: 120).isActive = true
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
        elements = []
        score = 0
        scoreView.scoreLabel.text = "0"
        let element = Element(randome(), randome())
        elements.append(element)
        
        let bestScore = databaseService.getBestScore()
        scoreBestView.scoreLabel.text = String(bestScore)
    }
    
    func addElement() {
        let isNotAdded = true
        var isNotMatch = true
        if elements.count == 16 {
            isNotMatch = false
            endOfGame()
        }
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
    
    func endOfGame() {
        if score > databaseService.getBestScore() {
            databaseService.saveBestScore(score: score)
        }
        let nav = UINavigationController(rootViewController: EndOfGameController(score: String(score)))
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
//    MARK: - Selectors
    
    @objc func handleSwipeLeft() {
        var tempElements: [Element] = []
        
        for i in 0...3 {
            var yElements: [Element] = []
            for item in elements {
                if item.y == i {
                    yElements.append(item)
                }
            }
            yElements = yElements.sorted(by: { $0.x < $1.x})
            if yElements.isEmpty { continue }
            if yElements.count == 1 {
                yElements[0].x = 0
                tempElements += yElements
            } else {
                for j in 1..<yElements.count {
                    if yElements[j-1].number == yElements[j].number {
                        yElements[j-1].toSwipe()
                        score += yElements[j-1].number
                        scoreView.scoreLabel.text = String(score)
                        yElements[j].number = 0
                        yElements[j-1].isTransform = true
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
                        score += yElements[j-1].number
                        scoreView.scoreLabel.text = String(score)
                        yElements[j].number = 0
                        yElements[j-1].isTransform = true
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
         var tempElements: [Element] = []
        
        for i in 0...3 {
            var xElements: [Element] = []
            for item in elements {
                if item.x == i {
                    xElements.append(item)
                }
            }
            xElements = xElements.sorted(by: { $0.y < $1.y })
            if xElements.isEmpty { continue }
            if xElements.count == 1 {
                xElements[0].y = 0
                tempElements += xElements
            } else {
                for j in 1..<xElements.count {
                    if xElements[j-1].number == xElements[j].number {
                        xElements[j-1].toSwipe()
                        score += xElements[j-1].number
                        scoreView.scoreLabel.text = String(score)
                        xElements[j].number = 0
                        xElements[j-1].isTransform = true
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
        var tempElements: [Element] = []
        
        for i in 0...3 {
            var xElements: [Element] = []
            for item in elements {
                if item.x == i {
                    xElements.append(item)
                }
            }
            xElements = xElements.sorted(by: { $0.y > $1.y })
            if xElements.isEmpty { continue }
            if xElements.count == 1 {
                xElements[0].y = 3
                tempElements += xElements
            } else {
                for j in 1..<xElements.count {
                    if xElements[j-1].number == xElements[j].number {
                        xElements[j-1].toSwipe()
                        score += xElements[j-1].number
                        scoreView.scoreLabel.text = String(score)
                        xElements[j].number = 0
                        xElements[j-1].isTransform = true
                    }
                }
                xElements.removeAll {$0.number == 0}
                var index = 3
                for j in 0..<xElements.count {
                    xElements[j].y = index
                    index -= 1
                }
                xElements = xElements.sorted(by: { $0.y < $1.y })
                tempElements += xElements
            }
        }
        elements = tempElements
        addElement()
    }
}

//  MARK: - Extensions

extension PlayingFieldController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifire, for: indexPath) as! PlayingFieldCell
        cell.numberLaber.text = ""
        cell.backgroundColor = .collectionCellBackground
        for (index, item) in elements.enumerated() {
            if item.x == indexPath.row && item.y == indexPath.section {
                if item.isNew {
                    cell.alpha = 0.1
                    UIView.animate(withDuration: 1) {
                        cell.alpha = 1
                        self.elements[index].isNew = false
                    }
                }
                if item.isTransform {
                    cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    UIView.animate(withDuration: 0.6) {
                        cell.transform = CGAffineTransform(scaleX: 1, y: 1)
                        self.elements[index].isTransform = false
                    }
                }
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
