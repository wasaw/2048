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
    private let newGameButton = NewGameButtom()
    
    enum Side {
        case left
        case right
        case up
        case down
    }
    
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
        configureNewGameButton()
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
    
    func configureNewGameButton() {
        view.addSubview(newGameButton)
        newGameButton.translatesAutoresizingMaskIntoConstraints = false
        newGameButton.leftAnchor.constraint(equalTo: scoreView.leftAnchor).isActive = true
        newGameButton.topAnchor.constraint(equalTo: scoreView.bottomAnchor, constant: 15).isActive = true
        newGameButton.rightAnchor.constraint(equalTo: scoreView.rightAnchor).isActive = true
        newGameButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        newGameButton.delegate = self
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
        
        DispatchQueue.main.async {
            let bestScore = self.databaseService.getBestScore()
            self.scoreBestView.scoreLabel.text = String(bestScore)
        }
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
            DispatchQueue.main.async {
                self.databaseService.saveBestScore(score: self.score)
            }
        }
        let nav = UINavigationController(rootViewController: EndOfGameController(score: String(score)))
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func handleSwipe(side : Side) {
        var tempElements: [Element] = []

        for i in 0...3 {
            var axisElements: [Element] = []
            for item in elements {
                if item.y == i && (side == .left || side == .right) {
                    axisElements.append(item)
                } else if item.x == i && (side == .up || side == .down) {
                    axisElements.append(item)
                }
            }
            switch side {
            case .left:
                axisElements = axisElements.sorted(by: { $0.x < $1.x })
            case .right:
                axisElements = axisElements.sorted(by: { $0.x > $1.x })
            case .up:
                axisElements = axisElements.sorted(by: { $0.y < $1.y })
            case .down:
                axisElements = axisElements.sorted(by: { $0.y > $1.y })
            }

            if axisElements.isEmpty { continue }
            if axisElements.count == 1 {
                switch side {
                case .left:
                    axisElements[0].x = 0
                case .right:
                    axisElements[0].x = 3
                case .up:
                    axisElements[0].y = 0
                case .down:
                    axisElements[0].y = 3
                }
                tempElements += axisElements
            } else {
                for j in 1..<axisElements.count {
                    if axisElements[j-1].number == axisElements[j].number {
                        axisElements[j-1].toSwipe()
                        score += axisElements[j-1].number
                        scoreView.scoreLabel.text = String(score)
                        axisElements[j].number = 0
                        axisElements[j-1].isTransform = true
                    }
                }
                axisElements.removeAll {$0.number == 0}
                var index = 3
                for j in 0..<axisElements.count {
                    switch side {
                    case .left:
                        axisElements[j].x = j
                    case .right:
                        axisElements[j].x = index
                        index -= 1
                    case .up:
                        axisElements[j].y = j
                    case .down:
                        axisElements[j].y = index
                        index -= 1
                    }
                }
                if side == .right {
                    axisElements = axisElements.sorted(by: { $0.x < $1.x})
                } else if side == .down {
                    axisElements = axisElements.sorted(by: { $0.y < $1.y})
                }
                tempElements += axisElements
            }
        }
        elements = tempElements
        addElement()
    }
    
//    MARK: - Selectors
    
    @objc func handleSwipeLeft() {
        handleSwipe(side: .left)
    }
    
    @objc func handleSwipeRight() {
        handleSwipe(side: .right)
    }
    
    @objc func handleSwipeUp() {
        handleSwipe(side: .up)
    }
    
    @objc func handleSwipeDown() {
        handleSwipe(side: .down)
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
                cell.numberLaber.font = UIFont.boldSystemFont(ofSize: item.fontSize.rawValue)
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

extension PlayingFieldController: NewGameButtonDelegate {
    func startNewGame() {
        start()
        collectionView.reloadData()
    }
}
