//
//  BattleShipView.swift
//  BattleShip


import UIKit

class BattleShipView: UIView {
    var currentPlayerGrid: [[GridCell]]
    var currentPlayerGridView: GridView
    
    var opponentPlayerGrid: [[GridCell]]
    var opponentPlayerGridView: GridView
    
    let hitsLabel = UILabel()
    let missesLabel = UILabel()
    let remainingLabel = UILabel()
    let winningPlayerLabel = UILabel()

    var winningPlayersName: String?
    
    init(frame: CGRect, currentPlayerGrid: [[GridCell]], opponentPlayerGrid: [[GridCell]], shipCoordsCP: [String: Int], creator: BattleShipViewController, stats: (Int, Int, Int)) {
        self.opponentPlayerGrid = opponentPlayerGrid
        self.opponentPlayerGridView = GridView(frame: CGRect.zero, grid: opponentPlayerGrid, creator: creator)
        
        self.currentPlayerGrid = currentPlayerGrid
        self.currentPlayerGridView = GridView(frame: CGRect.zero, grid: currentPlayerGrid, shipCoordinatesCP: shipCoordsCP)
        
        hitsLabel.textColor = .white
        hitsLabel.text = "Hits: \(stats.0)"
        hitsLabel.textAlignment = .center
        
        missesLabel.textColor = .white
        missesLabel.text = "Misses: \(stats.1)"
        missesLabel.textAlignment = .center
        
        remainingLabel.textColor = .white
        remainingLabel.text = "Remaining:  \(stats.2)"
        remainingLabel.textAlignment = .center
        
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        if let winningPlayersName = winningPlayersName {
            winningPlayerLabel.textColor = .white
            winningPlayerLabel.text = " \(winningPlayersName) wins!"
            winningPlayerLabel.textAlignment = .center
        }
        addSubview(opponentPlayerGridView)
        addSubview(currentPlayerGridView)
        addSubview(hitsLabel)
        addSubview(missesLabel)
        addSubview(remainingLabel)
        addSubview(winningPlayerLabel)
        super.draw(rect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        if(bounds.height > bounds.width) {
            self.opponentPlayerGridView.frame = CGRect(x: frame.width / 4, y: 2 * navigationBarHeight! + 10.0, width: frame.width / 2, height: frame.width / 2)
            self.currentPlayerGridView.frame = CGRect(x: frame.width / 4, y: opponentPlayerGridView.frame.maxY + 10, width: frame.width / 2, height: frame.width / 2)
            self.hitsLabel.frame = CGRect(x: frame.width / 4, y: currentPlayerGridView.frame.maxY + 10, width: frame.width / 2, height: 20)
            self.missesLabel.frame = CGRect(x: frame.width / 4, y: hitsLabel.frame.maxY + 10, width: frame.width / 2, height: 20)
            self.remainingLabel.frame = CGRect(x: frame.width / 4, y: missesLabel.frame.maxY + 10, width: frame.width / 2, height: 20)
            self.winningPlayerLabel.frame = CGRect(x: frame.width / 4, y: remainingLabel.frame.maxY + 10, width: frame.width / 2, height: 20)
        }
        else {
            self.opponentPlayerGridView.frame = CGRect(x: 2 * navigationBarHeight! + 10.0, y: frame.height / 4, width: frame.height / 2, height: frame.height / 2)
            self.currentPlayerGridView.frame = CGRect(x: opponentPlayerGridView.frame.maxX + 10, y: frame.height / 4, width: frame.height / 2, height: frame.height / 2)
            self.hitsLabel.frame = CGRect(x: currentPlayerGridView.frame.maxX + 10, y: currentPlayerGridView.frame.minY + 10, width: frame.height / 2, height: 20)
            self.missesLabel.frame = CGRect(x: currentPlayerGridView.frame.maxX + 10, y: hitsLabel.frame.maxY + 5, width: frame.height / 2, height: 20)
            self.remainingLabel.frame = CGRect(x: currentPlayerGridView.frame.maxX + 10, y: missesLabel.frame.maxY + 5, width: frame.height / 2, height: 20)
            self.winningPlayerLabel.frame = CGRect(x: currentPlayerGridView.frame.maxX + 10, y: remainingLabel.frame.maxY + 5, width: frame.height / 2, height: 20)
        }
    }
    
    func setWinningPlayers(name: String) {
        self.winningPlayersName = name
    }
    
}
