//
//  Game.swift
//  BattleShip


import Foundation

let gameLock = NSLock()

class Game: Codable {
    private var winningPlayersName: String?
    
    private var firstPlayerName: String
    private var firstPlayerShips: [Ship]
    private var firstPlayerHits: Int
    private var firstPlayerMisses: Int
    private var firstPlayerScore: Int
    private var firstPlayerMapState: [[GridCell]]
    
    private var secondPlayerName:String
    private var secondPlayerShips: [Ship]
    private var secondPlayerHits: Int
    private var secondPlayerMisses: Int
    private var secondPlayerScore: Int
    private var secondPlayerMapState: [[GridCell]]
    
    private var playersTurn: String
    
    init(firstPlayerName: String, secondPlayerName: String, firstPlayerShips: [Ship], secondPlayerShips: [Ship]) {
        self.firstPlayerName = firstPlayerName
        self.firstPlayerShips = firstPlayerShips
        self.firstPlayerHits = 0
        self.firstPlayerMisses = 0
        self.firstPlayerScore = 0
        firstPlayerMapState = generateGrid()
        
        self.secondPlayerName = secondPlayerName
        self.secondPlayerShips = secondPlayerShips
        self.secondPlayerHits = 0
        self.secondPlayerMisses = 0
        self.secondPlayerScore = 0
        secondPlayerMapState = generateGrid()
        
        playersTurn = "first"
    }
    
    // First bool represents a hit, second bool represents a sunken
    // battle ship, third bool indicates that the player won the game
    func fire(coord: (Int, Int))->Bool {
        let y = coord.0
        let x = coord.1
        
        gameLock.lock()
        var result: (CellStatus, ShipStatus) = (.MISS, .ERROR)
        // if first players turn iterate over seconds players ships and
        // check to see if the coord is a match.
        // else do the same but with the first players ships
        var miss = true
        if isFirstPlayersTurn() {
            for ship in secondPlayerShips {
                result = ship.hit(coord: coord)
                // if sink increment hits and score
                // else if just hit only increment hits
                if result.1 == ShipStatus.SUNK && result.0 == .HIT{
                    firstPlayerScore += 1
                    firstPlayerHits += 1
                    secondPlayerMapState[y][x].setCellStatus(status: .HIT)
                    miss = false
                    if firstPlayerScore == 5 { winningPlayersName = firstPlayerName }
                    break
                } else if result.0 == CellStatus.HIT{
                    firstPlayerHits += 1
                    secondPlayerMapState[y][x].setCellStatus(status: .HIT)
                    miss = false
                    break
                }
            }
            if miss {
                firstPlayerMisses += 1
                secondPlayerMapState[y][x].setCellStatus(status: .MISS)
            }
        } else {
            for ship in firstPlayerShips {
                result = ship.hit(coord: coord)
                // if sink increment hits and score
                // else if just hit only increment hits
                if result.1 == ShipStatus.SUNK && result.0 == .HIT{
                    secondPlayerScore += 1
                    secondPlayerHits += 1
                    firstPlayerMapState[y][x].setCellStatus(status: .HIT)
                    if secondPlayerScore == 5 { winningPlayersName = secondPlayerName }
                    miss = false
                    break
                } else if result.0 == CellStatus.HIT{
                    secondPlayerHits += 1
                    firstPlayerMapState[y][x].setCellStatus(status: .HIT)
                    miss = false
                    break
                }
            }
            if miss {
                secondPlayerMisses += 1
                firstPlayerMapState[y][x].setCellStatus(status: .MISS)
            }
        }
        togglePlayersTurn()
        gameLock.unlock()
        writeGames(gamesToWrite: games)
        return result.0 == .HIT
    }
    
    func isFirstPlayersTurn()->Bool {
        return playersTurn == "first"
    }
    
    func togglePlayersTurn() {
        if playersTurn == "first" { playersTurn = "second" }
        else { playersTurn = "first" }
    }
    
    func getFirstPlayersShipsLeft()->(String, Int) {
        return (firstPlayerName, 5 - secondPlayerScore)
    }
    
    func getSecondPlayersShipsLeft()->(String, Int) {
        return (secondPlayerName, 5 - firstPlayerScore)
    }
    
    // returns first players turn
    func getFirstPlayersName()->String {
        return firstPlayerName
    }
    
    // returns second players name
    func getSecondPlayersName()->String {
        return secondPlayerName
    }
    
    // returns winning players name
    func getWinningPlayersName()->String? {
        return winningPlayersName
    }
    
    // First String is the current players name, and
    // the second string is his opponents name
    func getNames()->(String, String) {
        if isFirstPlayersTurn() {
            return (firstPlayerName, secondPlayerName)
        } else {
            return (secondPlayerName, firstPlayerName)
        }
    }
    
    
    // Get the stats of the current player
    func getCurrentPlayersHitsMissesScore()->(Int, Int, Int) {
        if isFirstPlayersTurn() {
            return getFirstPlayersHitsMissesRemaining()
        } else {
            return getSecondPlayersHitsMissesRemaining()
        }
    }
    
    // Get the stats of the first player
    func getFirstPlayersHitsMissesRemaining()->(Int, Int, Int) {
        var data: (Int, Int, Int)
        gameLock.lock()
        data = (firstPlayerHits, firstPlayerMisses, 5 - firstPlayerScore)
        gameLock.unlock()
        return data
    }
    
    // Get the stats of the second player
    func getSecondPlayersHitsMissesRemaining()->(Int, Int, Int) {
        var data: (Int, Int, Int)
        gameLock.lock()
        data = (secondPlayerHits, secondPlayerMisses, 5 - secondPlayerScore)
        gameLock.unlock()
        return data
    }

    //get first player ship coordinates
    func getFirstPlayerShipCoordinates()->[String: Int] {
        var shipCoords = [String: Int].init()
        for ship in firstPlayerShips {
            ship.getShipsCoordinates().forEach { (k,v) in shipCoords[k] = 0 }
        }
        return shipCoords
    }
    
    //get first player ship coordinates
    func getSecondPlayerShipCoordinates()->[String: Int] {
        var shipCoords = [String: Int].init()
        for ship in secondPlayerShips {
            ship.getShipsCoordinates().forEach { (k,v) in shipCoords[k] = 0 }
        }
        return shipCoords
    }
    
    //get first player ship coordinates
    func getFirstPlayerGrid()->[[GridCell]] {
        return firstPlayerMapState
    }
    
    //get first player ship coordinates
    func getSecondPlayerGrid()->[[GridCell]] {
        return secondPlayerMapState
    }
    
    func isGameOver()->Bool {
        if winningPlayersName != nil {
            return true
        } else {
            return false
        }
    }
}
