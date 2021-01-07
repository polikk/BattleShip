//
//  ListViewController.swift
//  BattleShip
//


import UIKit

func readGames()->[Game] {
    let decoder = JSONDecoder()
    var gamesRead = [Game].init()
    do {
        let filename = getDocumentsDirectory().appendingPathComponent("games.json")
        let data = try  Data(contentsOf: filename, options: .mappedIfSafe)
        gamesRead = try decoder.decode([Game].self, from: data)
    } catch let error {
        print(error.localizedDescription)
    }
    return gamesRead
}

func writeGames(gamesToWrite: [Game]) {
    let encoder = JSONEncoder()
    do {
        let data = try encoder.encode(gamesToWrite)
        let filename = getDocumentsDirectory().appendingPathComponent("games.json")
        try data.write(to: filename, options: .completeFileProtection)
        try String(data: data, encoding: .utf8)!.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
    } catch let error {
        print(error.localizedDescription)
    }
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

func tupleToString(tup: (Int, Int))->String{
    return "(\(String(tup.0)), \(String(tup.1)))"
}


var games = readGames()
var currentGame: Game?

class GameListCell: UITableViewCell {
    static let lock = NSLock()
    static var count = 0
    
    let increment: Void = {
        GameListCell.lock.lock()
        
        defer{ GameListCell.lock.unlock() }
        GameListCell.count += 1
    }()
    
    deinit {
        GameListCell.lock.lock()
        
        defer{ GameListCell.lock.unlock() }
        GameListCell.count -= 1
    }
}

class GameListViewController: UIViewController {
    private var gameTableView: UITableView?
    private let gameStates = [String].init()
    private var playersTurn: Int?

    override func loadView() {
        // Todo: add newgame button
        super.loadView()
        self.title = "Current Games"
        
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector (GameListViewController.newGame))
        self.navigationItem.rightBarButtonItem?.title = "New Game"
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        let rightButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItem.Style.done, target: self, action: #selector(GameListViewController.toggleEdit))
        self.navigationItem.leftBarButtonItem = rightButton
        
        self.gameTableView = UITableView(frame: self.view.frame, style: UITableView.Style.grouped)
        self.gameTableView!.allowsSelectionDuringEditing = true
        self.gameTableView!.dataSource = self
        self.gameTableView!.delegate = self
        self.gameTableView!.register(GameListCell.self, forCellReuseIdentifier: String(describing: GameListCell.self))
        self.view.addSubview(self.gameTableView!)
        
        gameTableView!.translatesAutoresizingMaskIntoConstraints = false
        let views: [String:Any] = ["view": self.view, "subview": gameTableView!]
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
        self.gameTableView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameTableView?.reloadData()
    }
    
    @objc func toggleEdit()
    {
        if(self.gameTableView!.isEditing == true)
        {
            self.navigationItem.rightBarButtonItem?.title = "Done"
        }
        else
        {
            self.navigationItem.rightBarButtonItem?.title = "Edit"
        }
        self.gameTableView!.isEditing.toggle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.gameTableView!.reloadData()
    }

    @objc func loadGame(gameIdx: Int) {
        // Bring up game boards
        currentGame = games[gameIdx]
        guard let currentGame = currentGame else {
            fatalError("Never going to see this message")
        }
        navigationController?.pushViewController(BattleShipViewController(coordsFP: currentGame.getFirstPlayerShipCoordinates(), coordsSP: currentGame.getSecondPlayerShipCoordinates(), firstPlayerGrid: currentGame.getFirstPlayerGrid(), secondPlayerGrid: currentGame.getSecondPlayerGrid()), animated: true)
        self.gameTableView?.reloadData()
    }
    
    @objc func newGame() {
        navigationController?.pushViewController(CreateGameViewController(), animated: true)
        self.gameTableView?.reloadData()
    }
}

extension GameListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GameListCell.self)) as? GameListCell else {
            fatalError("Could not dequeue reusable cell of type \(String(describing: GameListCell.self))")
        }
        _ = cell.increment
        return cell
    }
}

extension GameListViewController: UITableViewDelegate {
    // Create text label for row in UITableView
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.textAlignment = .left
        let game = games[indexPath.row]
        var message = "Status: "
        if let winner = game.getWinningPlayersName() {
            message += "Finished, Winner: \(winner),"
        } else {
            message += "In Progress, Turn: \(game.getNames().0), "
        }
        let p1Dat = game.getFirstPlayersShipsLeft()
        let p2Dat = game.getSecondPlayersShipsLeft()
        message += "\(p1Dat.0) ships left: \(String(p1Dat.1)), \(p2Dat.0) ships left: \(String(p2Dat.1))"
        cell.textLabel?.text = message
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 8.0)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        games.remove(at: indexPath.row)
        writeGames(gamesToWrite: games)
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            games.remove(at: indexPath.row)
            tableView.reloadData()
        } else { loadGame(gameIdx: indexPath.row) }
    }
}
