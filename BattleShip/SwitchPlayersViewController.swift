//
//  ChangePlayersViewController.swift
//  BattleShip


import UIKit
class SwitchPlayersViewController: UIViewController {
    let switchPlayersView = SwitchPlayersView()
    
    private var firstPlayerGrid: [[GridCell]]
    private var secondPlayerGrid: [[GridCell]]
    
    private var firstPlayerShipCoords: [String: Int]
    private var secondPlayerShipCoords: [String: Int]
    
    init(firstPlayerGrid: [[GridCell]], coordsFP: [String: Int], secondPlayerGrid: [[GridCell]], coordsSP: [String: Int]) {
        self.firstPlayerGrid = firstPlayerGrid
        self.firstPlayerShipCoords = coordsFP
        
        self.secondPlayerGrid = secondPlayerGrid
        self.secondPlayerShipCoords = coordsSP
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        switchPlayersView.frame = self.view.frame
        self.view.addSubview(switchPlayersView)
        switchPlayersView.translatesAutoresizingMaskIntoConstraints = false
        let views: [String:Any] = ["view": self.view, "subview": switchPlayersView]
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
        switchPlayersView.switchPlayersButton.addTarget(self, action: #selector(backToGame), for: UIControl.Event.touchUpInside)
    }
    
    @objc func backToGame() {
        navigationController?.pushViewController(BattleShipViewController(coordsFP: firstPlayerShipCoords, coordsSP: secondPlayerShipCoords, firstPlayerGrid: firstPlayerGrid, secondPlayerGrid: secondPlayerGrid), animated: true)
    }
}
