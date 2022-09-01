import UIKit


class RepositoryViewController: UITableViewController {
    
    private let organization = "Apple"
    
    
    /** life cycle */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = organization + " Repositories"
        
        /** 당겨서 새로고침 */
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .white
        refreshControl.tintColor = .darkGray
        refreshControl.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.register(RepositoryCell.self, forCellReuseIdentifier: "RepositoryCell")
        tableView.rowHeight = 140
    }
    
    @objc func refresh() {
        
    }
}


extension RepositoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath) as? RepositoryCell else { return UITableViewCell()}
    
        return cell
    }
}
