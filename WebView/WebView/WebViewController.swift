import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webViewGroup: UIView!
    
    var search: String = ""
    var url: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = search
    }

}
