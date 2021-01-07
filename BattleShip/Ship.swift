//
//  Ship.swift
//  BattleShip


import Foundation

enum ShipStatus: Int, Codable {
    case AFLOAT = 0
    case SUNK = 1
    case ERROR = 2
}

let shipLock = NSLock.init()

class Ship: Codable {
    private var size: Int
    private var hitCount: Int
    var coords = [String: CellStatus]()
    var shipStatus: ShipStatus = .AFLOAT
    
    init(size: Int) {
        self.size = size
        self.hitCount = 0
    }
    
    func add(coord: (Int, Int)) {
        let id: String = tupleToString(tup: coord)
        self.coords[id] = .NOTFIREDAT
    }
    
    func hit(coord: (Int, Int))->(CellStatus, ShipStatus) {
        let id: String = tupleToString(tup: coord)
        var result: CellStatus
        if coords[id] != nil && coords[id] == .NOTFIREDAT {
            coords[id] = .HIT
            result = .HIT
            hitCount += 1
            if hitCount == size {
                shipStatus = .SUNK
            }
        } else { result = .MISS}
        return (result, shipStatus)
    }
    
    private func shipSunk(shipID: String)->Bool {
        return hitCount == size
    }
    
    func getSize()->Int {
        return self.size
    }
    
    func getShipsCoordinates()->[String: CellStatus] {
        return coords
    }
}
