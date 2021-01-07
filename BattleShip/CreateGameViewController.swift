//
//  CreateGameViewController.swift
//  BattleShip
//


import UIKit

// Indicates a direction to move from the origin
enum Direction: Int {
    case up = 0
    case down = 1
    case left = 2
    case right = 3
}

class CreateGameViewController: UIViewController {
    var createGameView: CreateGameView = CreateGameView()
    
    override func loadView() {
        super.loadView()
        self.title = "New Game"
        createGameView.frame = self.view.frame
        self.view.addSubview(createGameView)
        createGameView.translatesAutoresizingMaskIntoConstraints = false
        let views: [String:Any] = ["view": self.view, "subview": createGameView]
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:[view]-(<=1)-[subview(==400)]",
                                                      options: .alignAllCenterX,
                                                      metrics: nil,
                                                      views: views)
        
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:[view]-(<=1)-[subview(==300)]",
                                                        options: .alignAllCenterY,
                                                        metrics: nil,
                                                        views: views)
        self.view.addConstraints(vertical)
        self.view.addConstraints(horizontal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGameView.createGameButton.addTarget(self, action: #selector(createNewGame), for: UIControl.Event.touchUpInside)
    }
    
    // Creates a new game and pushes the BattleShipViewController
    @objc func createNewGame() {
        var firstPlayerName = createGameView.getFirstPlayerName()
        if firstPlayerName == "" {
            firstPlayerName = "First Player"
        }
        var secondPlayerName = createGameView.getSecondPlayerName()
        if secondPlayerName == "" {
            secondPlayerName = "Second Player"
        }
        
        let firstPlayerData = populateGrid()
        let shipsFP = firstPlayerData.0
        let shipCoordsFP = firstPlayerData.1
        
        let secondPlayerData = populateGrid()
        let shipsSP = secondPlayerData.0
        let shipCoordsSP = secondPlayerData.1
        
        let game = Game.init(firstPlayerName: firstPlayerName, secondPlayerName: secondPlayerName, firstPlayerShips: shipsFP, secondPlayerShips: shipsSP)
        games.append(game)
        currentGame = games.last
        navigationController?.pushViewController(BattleShipViewController(coordsFP: shipCoordsFP, coordsSP: shipCoordsSP), animated: true)
    }
    
    
    // Populate empty grid randomly with ships
    // Todo if there is time: refactor the following method to reduce code duplication
    func populateGrid()->([Ship], [String: Int]) {
        var ships = [Ship].init()
        
        // dictionary to check and see if size ship has already been generated
        var values = [Int: Int].init()
        // dictionary to check and see if ship already exists in the coordinates
        var shipCoords = [String: Int].init()

        while ships.count < 5  {
            var i = -1
            while true {
                i = Int.random(in: 0...4)
                if values[i] == nil {
                    values[i] = 0
                    break
                }
            }
            
            let ship = Ship.init(size: i + 1)
            var unsuccessful: Bool = true
            
            while unsuccessful {
                let row = Int.random(in: 0...9)
                let col = Int.random(in: 0...9)
                
                // if coordinates already have ship then continue
                if shipCoords[String(tupleToString(tup: (row, col)))] != nil { continue }
                guard let direction = Direction(rawValue: Int.random(in: 0...3)) else {
                    continue
                }
                
                var blocked = false
                switch direction {
                //*********************************************Case 0**************************
                case Direction.up:
                    for y in (row - i)...row {
                        // check to see if the coordinate is not available
                        blocked = (y < 0 || shipCoords[String(tupleToString(tup: (y, col)))] != nil)
                        if blocked { break }
                    }
                    if blocked { continue }
                    for y in (row - i)...row {
                        // add coordinates to map of coordinates with ships
                        ship.add(coord: (y, col))
                        shipCoords[String(tupleToString(tup: (y, col)))] = 0
                    }
                    ships.append(ship)
                    unsuccessful = false
                    
                //*********************************************Case 1***************************
                case Direction.down:
                    for y in row...(row + i) {
                        // check to see if the coordinate is not available
                        blocked = (y > 9 || shipCoords[String(tupleToString(tup: (y, col)))] != nil)
                        if blocked { break }
                    }
                    if blocked { continue }
                    for y in row...(row + i) {
                        // add coordinates to map of coordinates with ships
                        ship.add(coord: (y, col))
                        shipCoords[String(tupleToString(tup: (y, col)))] = 0
                    }
                    ships.append(ship)
                    unsuccessful = false
                    
                //*********************************************Case 2***************************
                case Direction.left:
                    for x in (col - i)...col {
                        // check to see if the coordinate is not available
                        blocked = (x < 0 || shipCoords[String(tupleToString(tup: (row, x)))] != nil)
                        if blocked { break }
                    }
                    if blocked { continue }
                    for x in (col - i)...col {
                        // add coordinates to map of coordinates with ships
                        ship.add(coord: (row, x))
                        shipCoords[String(tupleToString(tup: (row, x)))] = 0
                    }
                    ships.append(ship)
                    unsuccessful = false
                    
                //*********************************************Case 3****************************
                case Direction.right:
                    for  x in col...(col + i) {
                        // check to see if the coordinate is not available
                        blocked = (x > 9 || shipCoords[String(tupleToString(tup: (row, x)))] != nil)
                        if blocked { break }
                    }
                    if blocked { continue }
                    for x in col...(col + i) {
                        // add coordinates to map of coordinates with ships
                        ship.add(coord: (row, x))
                        shipCoords[String(tupleToString(tup: (row, x)))] = 0
                    }
                    ships.append(ship)
                    unsuccessful = false
                }
            }
        }
        return (ships, shipCoords)
    }
}
