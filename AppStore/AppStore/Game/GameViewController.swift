import UIKit

enum Section {
    case card
    case smallList
}

class GameViewController: UIViewController {
    
    @IBOutlet weak var btnProfile: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    let cardList: [Card] = CardList().cardList
    let gameList: [Game] = GameList().gameList
    
    var data = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
    }
    
    private func setView() {
        
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.topItem?.title = "게임"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        /*
        btnProfile.backgroundColor = .blue
        btnProfile.layer.cornerRadius = 18
         */
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CardTableCell", bundle: nil), forCellReuseIdentifier: "CardTableCell")
        tableView.register(UINib(nibName: "SmallListTableCell", bundle: nil), forCellReuseIdentifier: "SmallListTableCell")
        tableView.register(UINib(nibName: "BigListTableCell", bundle: nil), forCellReuseIdentifier: "BigListTableCell")
    }
}

extension GameViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        /*
        switch section {
        case 0:
            return cardList.count
        case 1:
            return gameList.count
        default:
            return 0
        }*/
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "CardTableCell", for: indexPath)
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "SmallListTableCell", for: indexPath)
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "BigListTableCell", for: indexPath)
        default:
            return cell
            
        }
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return CardCell.height
        case 1:
            return SmallListCell.height * 4 + 5
        case 2:
            return SmallListCell.height * 4
        default:
            return 0
        }
    }
}

extension GameViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        return true
    }
}
