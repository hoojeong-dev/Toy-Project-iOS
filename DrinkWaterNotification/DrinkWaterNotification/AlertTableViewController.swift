import UIKit
import UserNotifications

class AlertTableViewController: UITableViewController {
    
    var alerts: [Alert] = []
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customCell = UINib(nibName: "AlertTableViewCell", bundle: nil)
        tableView.register(customCell, forCellReuseIdentifier: "AlertTableViewCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(editAlertNotification), name: NSNotification.Name("edit"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteAlertNotification), name: NSNotification.Name("delete"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.alerts = alertList()
    }
    
    func alertList() -> [Alert] {
        guard let data = UserDefaults.standard.value(forKey: "alerts") as? Data,
              let alerts = try? PropertyListDecoder().decode([Alert].self, from: data) else { return [] }
        
        return alerts
    }

    @objc func editAlertNotification(_ notification: Notification) {
        guard let alert = notification.object as? Alert else { return }
        guard let index = self.alerts.firstIndex(where: { $0.id == alert.id }) else { return }
        var alertList = self.alertList()
        
        alertList[index] = alert
        
        alertList.sort { $0.date < $1.date }
        self.alerts = alertList
        
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts")
        
        self.tableView.reloadData()
    }
    
    @objc func deleteAlertNotification(_ notification: Notification) {
        guard let id = notification.object as? String else { return }
        guard let index = self.alerts.firstIndex(where: { $0.id == id }) else { return }
        
        userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [alerts[index].id])
        self.alerts.remove(at: index)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts")
        tableView.reloadData()
    }
    
    @IBAction func tapAddAlertButton(_ sender: UIBarButtonItem) {
        guard let AddAlertViewController = storyboard?.instantiateViewController(withIdentifier: "AddAlertViewController") as? AddAlertViewController else { return }
        
        AddAlertViewController.datePicked = {[weak self] date in
            guard let self = self else { return }
            var alertList = self.alertList()
            let newAlert = Alert(date: date, isOn: true)
            
            alertList.append(newAlert)
            alertList.sort { $0.date < $1.date }
            self.alerts = alertList
            
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts")
            
            self.tableView.reloadData()
        }
        
        if let presentationController = AddAlertViewController.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium(), .large()]
        }
        
        self.present(AddAlertViewController, animated: true, completion: nil)
    }
}

extension AlertTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlertTableViewCell", for: indexPath) as? AlertTableViewCell else { return UITableViewCell() }
        
        cell.alertSwitch.tag = indexPath.row
        cell.alertSwitch.isOn = alerts[indexPath.row].isOn
        cell.timeLabel.text = alerts[indexPath.row].time
        cell.meridiemLabel.text = alerts[indexPath.row].meridiem
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "🚰 물마실 시간"
        default:
            return nil
        }
    }
    
    // 선택한 셀 넘기기
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let AddAlertViewController = storyboard?.instantiateViewController(withIdentifier: "AddAlertViewController") as? AddAlertViewController else { return }
        
        let alert = self.alerts[indexPath.row]
        AddAlertViewController.setAlertMode = .edit(indexPath, alert)
        
        if let presentationController = AddAlertViewController.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium(), .large()]
        }
        
        self.present(AddAlertViewController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [alerts[indexPath.row].id])
            self.alerts.remove(at: indexPath.row)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts")
            tableView.reloadData()
        default:
            break
        }
    }
    
}
