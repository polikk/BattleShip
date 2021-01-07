//
//  BattleShipViewController.swift
//  BattleShip
//


import UIKit

var navigationBarHeight: CGFloat?
// Create grid that contains the coordinates of ships, as well as the ships with their hit coordinates.
func generateGrid()->[[GridCell]] {
    var grid = [[GridCell]].init()
    for _ in 0...9 {
        var row = [GridCell].init()
        for _ in 0...9 {
            row.append(GridCell())
        }
        grid.append(row)
    }
    return grid
}

class BattleShipViewController: UIViewController {
    
    private var firstPlayerView: BattleShipView?
    private var secondPlayerView: BattleShipView?
    
    private var firstPlayerGrid: [[GridCell]]
    private var secondPlayerGrid: [[GridCell]]
    
    private var firstPlayerShipCoords: [String: Int]
    private var secondPlayerShipCoords: [String: Int]
    
    init(coordsFP: [String: Int], coordsSP: [String: Int]) {
        self.firstPlayerGrid = generateGrid()
        self.firstPlayerShipCoords = coordsFP
        
        self.secondPlayerGrid = generateGrid()
        self.secondPlayerShipCoords = coordsSP
        
        super.init(nibName: nil, bundle: nil)
    }
    
    init(coordsFP: [String: Int], coordsSP: [String: Int], firstPlayerGrid: [[GridCell]], secondPlayerGrid: [[GridCell]]) {
        self.firstPlayerGrid = firstPlayerGrid
        self.firstPlayerShipCoords = coordsFP
        
        self.secondPlayerGrid = secondPlayerGrid
        self.secondPlayerShipCoords = coordsSP
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton: UIBarButtonItem = UIBarButtonItem(title: "Game List ⚓", style: UIBarButtonItem.Style.plain, target: self, action: #selector(BattleShipViewController.popToRoot))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationBarHeight = (self.navigationController?.navigationBar.frame.size.height)!
        
        firstPlayerView = BattleShipView(frame: self.view.bounds, currentPlayerGrid: firstPlayerGrid, opponentPlayerGrid: secondPlayerGrid, shipCoordsCP:  firstPlayerShipCoords, creator: self, stats: (currentGame?.getFirstPlayersHitsMissesRemaining())!)
        secondPlayerView = BattleShipView(frame: self.view.bounds, currentPlayerGrid: secondPlayerGrid, opponentPlayerGrid: firstPlayerGrid, shipCoordsCP: secondPlayerShipCoords, creator: self, stats: (currentGame?.getSecondPlayersHitsMissesRemaining())!)
        
        if let winningPlayer = currentGame!.getWinningPlayersName() {
            firstPlayerView!.setWinningPlayers(name: winningPlayer)
            secondPlayerView!.setWinningPlayers(name: winningPlayer)
        }
        
        if (currentGame?.isFirstPlayersTurn())! {
            self.view = firstPlayerView
        } else {
            self.view = secondPlayerView
        }
    }
    
    @objc func popToRoot() {
        currentGame = nil
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
}

extension BattleShipViewController: CellViewDelegate {
    func launchMissileAt(coord: (Int, Int))->Bool {
        guard let currentGame = currentGame else {
            fatalError("Current game not initialized in instance of BattleShipViewController")
        }
        
        let result = currentGame.fire(coord: coord)
        if let winningPlayer = currentGame.getWinningPlayersName() {
            firstPlayerView!.setWinningPlayers(name: winningPlayer)
            secondPlayerView!.setWinningPlayers(name: winningPlayer)
            self.view.setNeedsLayout()
        }
        return result
    }
    
    func generateSwitchPlayersController() {
        _ = navigationController?.pushViewController(SwitchPlayersViewController(firstPlayerGrid: firstPlayerGrid, coordsFP: firstPlayerShipCoords, secondPlayerGrid: secondPlayerGrid, coordsSP: secondPlayerShipCoords), animated: true)
    }
}
