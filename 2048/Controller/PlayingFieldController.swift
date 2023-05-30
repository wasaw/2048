//
//  PlayingFieldController.swift
//  2048
//
//  Created by Александр Меренков on 2/11/22.
//

import UIKit

private enum Constants {
    static let logoPaddings: CGFloat = 20
    static let logoDimensions: CGFloat = 120
    static let scoreViewPaddings: CGFloat = 20
    static let scoreViewHeight: CGFloat = 100
    static let buttonPaddings: CGFloat = 15
    static let buttonHeight: CGFloat = 40
    static let collectionViewPaddingTop: CGFloat = 45
    static let collectionViewDimensions: CGFloat = 20
    static let minimumSectionSpacing: CGFloat = 0
    static let fieldSize = 4
}

final class PlayingFieldController: UIViewController {
    
//    MARK: - Properties
    
    private let insets = UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 10)
    private var elements: [Element] = []
    private var score = 0
    
    private var collectionView: UICollectionView?
    private let scoreView = ScoreView()
    private let scoreBestView = ScoreView()
    private let databaseService = DatabaseService.shared
    private let logoView = LogoView()
    private let newGameButton = NewGameButtom()
    
    private var bestScore = 0
    
//    MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureSwipeGestureRecognizer()
        start()
        
        view.backgroundColor = .playingBackground
    }
    
//    MARK: - Helpers
    
    private func configureUI() {
        configureLogo()
        configureScoreView()
        configureNewGameButton()
        configureCollectionView()
    }
    
    private func configureLogo() {
        view.addSubview(logoView)
        logoView.anchor(leading: view.leadingAnchor,
                        top: view.safeAreaLayoutGuide.topAnchor,
                        paddingLeading: Constants.logoPaddings,
                        paddingTop: Constants.logoPaddings,
                        width: Constants.logoDimensions,
                        height: Constants.logoDimensions)
    }
    
    private func configureScoreView() {
        let stack = UIStackView(arrangedSubviews: [scoreView, scoreBestView])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 15
        view.addSubview(stack)
        stack.anchor(leading: logoView.trailingAnchor,
                     top: logoView.topAnchor,
                     trailing: view.trailingAnchor,
                     paddingLeading: Constants.scoreViewPaddings,
                     paddingTrailing: -Constants.scoreViewPaddings,
                     height: Constants.scoreViewHeight)
    }
    
    private func configureNewGameButton() {
        view.addSubview(newGameButton)
        newGameButton.anchor(leading: scoreView.leadingAnchor,
                             top: scoreView.bottomAnchor,
                             trailing: scoreView.trailingAnchor,
                             paddingTop: Constants.buttonPaddings,
                             height: Constants.buttonHeight)
        
        newGameButton.delegate = self
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let collectionView = collectionView else { return }
        collectionView.register(PlayingFieldCell.self, forCellWithReuseIdentifier: PlayingFieldCell.reuseIdentifire)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        let side = view.frame.width - 40
        collectionView.anchor(leading: view.leadingAnchor,
                              top: newGameButton.bottomAnchor,
                              trailing: view.trailingAnchor,
                              paddingLeading: Constants.collectionViewDimensions,
                              paddingTop: Constants.collectionViewPaddingTop,
                              paddingTrailing: -Constants.collectionViewDimensions,
                              width: side,
                              height: side + 15)
        collectionView.layer.cornerRadius = 5
        collectionView.backgroundColor = .collectionBorderBackground
    }
    
    private func configureSwipeGestureRecognizer() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        collectionView?.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        collectionView?.addGestureRecognizer(swipeRight)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeUp))
        swipeUp.direction = .up
        collectionView?.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
        swipeDown.direction = .down
        collectionView?.addGestureRecognizer(swipeDown)
    }
    
    private func start() {
        elements = []
        score = 0
        scoreView.setTitle("Счет")
        scoreBestView.setTitle("Лучший")
        addElement()
        scoreView.updateScore(score)
        
        DispatchQueue.main.async {
            self.databaseService.getBestScore { result in
                switch result {
                case .success(let score):
                    self.bestScore = score
                case .failure(_):
                    self.bestScore = 0
                }
            }
            self.scoreBestView.updateScore(self.bestScore)
        }
    }

    private func addElement() {
        if elements.count == 16 {
            endOfGame()
        } else {
            let element = getNewElement()
            elements.append(element)
            collectionView?.reloadData()
        }
    }

    private func getNewElement() -> Element {
        var isNotEmpty = true
        var x = 0
        var y = 0
        while isNotEmpty {
            x = Int.random(in: 0...3)
            y = Int.random(in: 0...3)
            
            isNotEmpty = checkRandom(x, y)
        }
        
        func checkRandom(_ x: Int, _ y: Int) -> Bool {
            for item in elements {
                if item.x == x && item.y == y {
                    return true
                }
            }
            return false
        }
        return Element(x, y)
    }
    
    private func endOfGame() {
        if score > bestScore {
            DispatchQueue.main.async {
                self.databaseService.saveBestScore(score: self.score) { result in
                    switch result {
                    case .success(_):
                        break
                    case .failure(_):
                        break
                    }
                }
            }
        }
        let vc = EndOfGameController(score)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        start()
    }
    
    private func handleSwipe(side : Direction) {
        var updateElements: [Element] = []

        for row in 0...3 {
            var axisElements: [Element] = []
            for item in elements {
                if item.y == row && (side == .left || side == .right) {
                    axisElements.append(item)
                } else if item.x == row && (side == .up || side == .down) {
                    axisElements.append(item)
                }
            }
            if !axisElements.isEmpty {
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
                    updateElements += axisElements
                } else {
                    CollapseArray(&axisElements)
                    SetIndexElements(&axisElements, direction: side)
                    
                    updateElements += axisElements
                }
            }
        }
        elements = updateElements
        addElement()
    }
    
    private func CollapseArray(_ elements: inout [Element]) {
        for j in 1..<elements.count {
           if elements[j-1].number == elements[j].number {
               elements[j-1].Collapse()
               score += elements[j-1].number
               scoreView.updateScore(score)
               elements[j].number = 0
               elements[j-1].isTransform = true
           }
        }
        elements.removeAll {$0.number == 0}
    }
    
    private func SetIndexElements(_ elements: inout [Element], direction: Direction) {
        var index = 3
        for j in 0..<elements.count {
            switch direction {
            case .left:
                elements[j].x = j
            case .right:
                elements[j].x = index
                index -= 1
            case .up:
                elements[j].y = j
            case .down:
                elements[j].y = index
                index -= 1
            }
        }
        if direction == .right {
            elements = elements.sorted(by: { $0.x < $1.x})
        }
        if direction == .down {
            elements = elements.sorted(by: { $0.y < $1.y})
        }
    }
    
//    MARK: - Selectors
    
    @objc private func handleSwipeLeft() {
        handleSwipe(side: .left)
    }
    
    @objc private func handleSwipeRight() {
        handleSwipe(side: .right)
    }
    
    @objc private func handleSwipeUp() {
        handleSwipe(side: .up)
    }
    
    @objc private func handleSwipeDown() {
        handleSwipe(side: .down)
    }
}

//  MARK: - Extensions

extension PlayingFieldController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.fieldSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlayingFieldCell.reuseIdentifire, for: indexPath) as? PlayingFieldCell else { return UICollectionViewCell() }
        cell.clear()
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
                cell.update(item)
            }
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Constants.fieldSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.minimumSectionSpacing
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

extension PlayingFieldController: NewGameButtonDelegate {
    func startNewGame() {
        start()
        collectionView?.reloadData()
    }
}
