//
//  GridView.swift
//  BattleShip


import UIKit

protocol CellViewDelegate: class {
    func launchMissileAt(coord: (Int, Int))->Bool
    func generateSwitchPlayersController()
}

let updateColorLock = NSLock()

class GridCellView: UIView {
    weak var delegate: CellViewDelegate?
    
    private var cell: GridCell
    private var coord: (Int, Int)
    private var isCPCell = false
    private var isShipCoord = false
    private var isGameOver = false
    
    init(frame: CGRect, cell: GridCell, coord: (Int, Int)) {
        self.cell = cell
        self.coord = coord
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let cellRect = CGRect(x: bounds.origin.x + 3, y: bounds.origin.y + 3, width: bounds.size.width - 1, height: bounds.size.width - 1)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(self.getCellColor().cgColor)
        context.addRect(cellRect)
        context.fill(cellRect)
    }
    
    
    func setAsCurrentPlayersCell() {
        isCPCell = true
    }
    
    func setAsShipCoord() {
        isShipCoord = true
    }

    private func getCellColor()-> UIColor {
        var currentColor: UIColor
        updateColorLock.lock()
        switch cell.getStatus() {
        case .HIT:
            currentColor = UIColor.red
        case .MISS:
            currentColor = UIColor.white
        case .NOTFIREDAT:
            if isShipCoord {
                currentColor = UIColor.lightGray
            } else {
                currentColor = UIColor.blue
            }
        case .ERROR:
            currentColor = UIColor.blue
        }
        updateColorLock.unlock()
        return currentColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isCPCell || self.isGameOver || cell.getStatus() != .NOTFIREDAT { return }
        guard let hit = delegate?.launchMissileAt(coord: coord) else { return }
        updateColorLock.lock()
        if hit {
            cell.setCellStatus(status: .HIT)
        } else {
            cell.setCellStatus(status: .MISS)
        }
        updateColorLock.unlock()
        self.setNeedsDisplay()
        delegate?.generateSwitchPlayersController()
    }
}

class GridView: UIView {
    var shipCoordinatesCP: [String: Int]?
    private var grid: [[GridCell]]
    let size = 10
    var creator: BattleShipViewController?
    
    init(frame: CGRect, grid: [[GridCell]], creator: BattleShipViewController) {
        self.grid = grid
        self.creator = creator
        super.init(frame: frame)
    }
    
    init(frame: CGRect, grid: [[GridCell]], shipCoordinatesCP: [String: Int]) {
        self.grid = grid
        self.shipCoordinatesCP = shipCoordinatesCP
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let cellSize:CGFloat = CGFloat(1) / CGFloat(size)
        for  y in 0...size-1 {
            for x in 0...size-1 {
                let cellFrame: CGRect = CGRect(x: CGFloat(x) * (bounds.size.width * cellSize),
                                               y: CGFloat(y) * (bounds.size.height * cellSize),
                                               width: bounds.size.width * cellSize, height: bounds.size.height * cellSize)
                let gridCellView = GridCellView(frame: cellFrame, cell: grid[y][x], coord: (y, x))
                if let shipCoordinatesCP = shipCoordinatesCP {
                    gridCellView.setAsCurrentPlayersCell()
                    if shipCoordinatesCP[String(tupleToString(tup: (y, x)))] != nil {
                        gridCellView.setAsShipCoord()
                    }
                }  else if let creator = creator {
                    gridCellView.delegate = creator
                }
                addSubview(gridCellView)
            }
        }
    }
}
