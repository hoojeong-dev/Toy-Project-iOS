//
//  UserInfoViewController.swift
//  Login
//
//  Created by 김후정 on 2022/06/07.
//

import UIKit

class UserInfoViewController: UIViewController {

    @IBOutlet weak var userEmailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = AppDelegate.user
        self.userEmailLabel.text = user?.profile.email
    }
}
