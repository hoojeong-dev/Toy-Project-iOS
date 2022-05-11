import UIKit

enum SetAlertMode {
    case new
    case edit(IndexPath, Alert)
}

class AddAlertViewController: UIViewController {

    var id: String?
    var setAlertMode: SetAlertMode = .new
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    @IBOutlet weak var removeAlertButton: UIButton!
    @IBOutlet weak var titleNavigationBar: UINavigationBar!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var datePicked: ((_ date:Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureView()
        self.configureEditMode()
    }
    
    private func configureView() {
        self.navigationItem.title = "알람 추가"
        self.removeAlertButton.isHidden = false
    }
    
    private func configureEditMode() {
        switch self.setAlertMode {
        case let .edit(_, alert):
            self.id = alert.id
            // datepicker에 나타나는 시간을 기존에 저장한 시간으로 바꾸는 코드 추가
            self.navigationItem.title = "알람 추가"
            self.removeAlertButton.isHidden = true
        
        default:
            break
        }
    }
    
    @IBAction func tapCancelButton(_ sender: UIBarButtonItem) {
        super.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapSaveButton(_ sender: UIBarButtonItem) {
        switch self.setAlertMode {
        case .new:
            datePicked?(datePicker.date)
            
        case let .edit(_, alert):
            let date = self.datePicker.date
            let editAlert = Alert(id: alert.id, date: date, isOn: true)
            NotificationCenter.default.post(name: NSNotification.Name("edit"), object: editAlert, userInfo: nil)
        }

        super.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapRemoveButton(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("delete"), object: id, userInfo: nil)
        super.dismiss(animated: true, completion: nil)
    }
}
