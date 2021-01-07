//
//  SwitchPlayersView.swift
//  BattleShip


import UIKit

class SwitchPlayersView: UIView {
    private var switchPlayersLabel: UILabel = UILabel()
    var switchPlayersButton: UIButton = UIButton()
    
    //Todo: make sure that there is no white space in players name
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        
        switchPlayersLabel.frame = CGRect(x: self.center.x + 60, y: 180, width: 200, height: 50)
        switchPlayersLabel.textColor = UIColor.red
        switchPlayersLabel.font = UIFont(name: "Copperplate", size: 10)
        switchPlayersLabel.text = "Hand the device to your enemy."
        self .addSubview(switchPlayersLabel)
        
        switchPlayersButton.frame = CGRect(x: self.center.x + 55, y: switchPlayersLabel.frame.maxY + 10, width: 200, height: 50)
        switchPlayersButton.backgroundColor = UIColor.red
        switchPlayersButton.setTitle("PRESS WHEN READY", for: UIControl.State())
        switchPlayersButton.setTitleColor(UIColor.black, for: UIControl.State())
        switchPlayersButton.titleLabel!.font = UIFont(name: "Copperplate", size: 10)
        switchPlayersButton.layer.cornerRadius = 15
        self.addSubview(switchPlayersButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
}

