import UIKit

class AlertTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // custom cell 연결
        let customCell = UINib(nibName: "AlertTableViewCell", bundle: nil)
        tableView.register(customCell, forCellReuseIdentifier: "AlertTableViewCell")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    @IBAction func tapAddAlertButton(_ sender: UIBarButtonItem) {
        guard let AddAlertViewController = storyboard?.instantiateViewController(withIdentifier: "AddAlertViewController") as? AddAlertViewController else { return }
        
        self.present(AddAlertViewController, animated: true, completion: nil)
    }
    
    @IBAction func tapEditAlertButton(_ sender: UIBarButtonItem) {
    
    }
}
