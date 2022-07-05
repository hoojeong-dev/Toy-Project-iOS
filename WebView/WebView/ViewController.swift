import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tvSearch: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    @IBAction func tappedSearch(_ sender: Any) {
        let text: String = tvSearch.text!
        
        if let navigationController = self.navigationController {
            
            if !(navigationController.topViewController?.description.contains("WebViewController"))! {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                
                viewController.search = text
                viewController.url = "https://m.search.naver.com/search.naver?sm=mtp_hty.top&where=m&query=\(text)"
                
                navigationController.pushViewController(viewController, animated: true)
            }
        }
    }
}

