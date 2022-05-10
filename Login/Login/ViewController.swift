//
//  ViewController.swift
//  Login
//
//  Created by 김후정 on 2022/06/07.
//

import UIKit
import GoogleSignIn
import Firebase

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //GIDSignIn.sharedInstance.
    }

    @IBAction func tapGoogleSignIn(_ sender: UIButton) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
          if let error = error {
              print("ERROR", error.localizedDescription)
            return
          }

          guard let authentication = user?.authentication,
                let idToken = authentication.idToken else { return }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)

            Auth.auth().signIn(with: credential) { _, _ in
                self.showUserInfoViewController()
            }
        }
    }
    
    private func showUserInfoViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let userInfoViewController = storyboard.instantiateViewController(identifier: "UserInfoViewController")
        
        userInfoViewController.modalPresentationStyle = .fullScreen
        UIApplication.shared.windows.first?.rootViewController?.show(userInfoViewController, sender: nil)
        
    }
}
