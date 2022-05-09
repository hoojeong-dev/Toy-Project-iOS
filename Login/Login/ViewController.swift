//
//  ViewController.swift
//  Login
//
//  Created by 김후정 on 2022/06/07.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }

    @IBAction func tapGoogleSignIn(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signIn()

        guard let UserInfoViewController =  self.storyboard?.instantiateViewController(withIdentifier: "UserInfoViewController") as? UserInfoViewController else { return }
                self.navigationController?.pushViewController(UserInfoViewController, animated: true)
    }
}
