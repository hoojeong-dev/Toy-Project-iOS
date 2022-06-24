import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var customNavigationBar: UIView!
    @IBOutlet weak var tvNavigationBarTitle: UILabel!
    @IBOutlet weak var btnProfile: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var lastContentOffSet: CGFloat = 0.0
    
    var data = AppStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
    }
    
    private func setView() {
        
        //let panGestureRecongnizer = UIPanGestureRecognizer(target: self, action: #selector(panAction(_ :)))
        //panGestureRecongnizer.delegate = self
        //self.view.addGestureRecognizer(panGestureRecongnizer)
        
        navigationItem.title = "게임"
        navigationController?.isNavigationBarHidden = true
        
        tvNavigationBarTitle.text = "게임"
        tvNavigationBarTitle.textColor = .black
        tvNavigationBarTitle.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        
        btnProfile.backgroundColor = .blue
        btnProfile.layer.cornerRadius = 18
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CardTableCell", bundle: nil), forCellReuseIdentifier: "CardTableCell")
    }
    
    @objc func panAction (_ sender : UIPanGestureRecognizer){
        let velocity = sender.velocity(in: tableView)
        
        if velocity.y < 0 {
            print("ssssss")
            self.navigationController?.isNavigationBarHidden = false
            self.customNavigationBar.isHidden = true
        }
        //else {
            //self.navigationController?.isNavigationBarHidden = true
            //self.customNavigationBar.isHidden = false
        //}
    }
}

extension GameViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardTableCell", for: indexPath) as? CardTableCell else { return UITableViewCell() }
        
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
}

extension GameViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        return true
    }
}

extension GameViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if self.lastContentOffSet <= 0 || self.lastContentOffSet > scrollView.contentOffset.y {
            self.navigationController?.isNavigationBarHidden = false
            self.customNavigationBar.isHidden = true
        }
        else if self.lastContentOffSet < scrollView.contentOffset.y {
            self.navigationController?.isNavigationBarHidden = true
            self.customNavigationBar.isHidden = false
        }
        
        self.lastContentOffSet = scrollView.contentOffset.y
    }
}
