//
//  GameListView.swift
//  BattleShip
//


import UIKit

class CreateGameView: UIView {
    var firstPlayerTextField: UITextField = UITextField()
    var secondPlayerTextField: UITextField = UITextField()
    var createGameButton: UIButton = UIButton()
    
    //Todo: make sure that there is no white space in players name
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blue
        
        firstPlayerTextField.backgroundColor = UIColor.white
        firstPlayerTextField.placeholder = "First Player's Name"
        firstPlayerTextField.textAlignment = NSTextAlignment.center
        self .addSubview(firstPlayerTextField)

        secondPlayerTextField.backgroundColor = UIColor.white
        secondPlayerTextField.placeholder = "Second Player's Name"
        secondPlayerTextField.textAlignment = NSTextAlignment.center
        self.addSubview(secondPlayerTextField)
        
        createGameButton.setTitle("Create Game", for: UIControl.State())
        createGameButton.backgroundColor = .black
        createGameButton.layer.cornerRadius = 15
        self.addSubview(createGameButton)
        

        firstPlayerTextField.frame = CGRect(x: self.center.x + 55, y: 180, width: 200, height: 50)
        secondPlayerTextField.frame = CGRect(x: self.center.x + 55, y: firstPlayerTextField.frame.maxY + 10, width: 200, height: 50)
        createGameButton.frame = CGRect(x: self.center.x + 55, y: secondPlayerTextField.frame.maxY + 10, width: 200, height: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    func getFirstPlayerName()->String {
        guard let firstPlayerName = firstPlayerTextField.text else {
            return "First Player"
        }
        return firstPlayerName
    }
    
    func getSecondPlayerName()->String {
        guard let secondPlayerName = secondPlayerTextField.text else {
            return "Second Player"
        }
        return secondPlayerName
    }
}
