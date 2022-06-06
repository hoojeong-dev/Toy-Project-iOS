import UIKit

class AddAlertViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    var datePicked: ((_ date:Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func tapCancelButton(_ sender: UIBarButtonItem) {
        super.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapSaveButton(_ sender: UIBarButtonItem) {
        datePicked?(datePicker.date)
        super.dismiss(animated: true, completion: nil)
    }
    
}
