//
//  LaunchViewController.swift
//  GrownStrong
//
//  Created by Aman on 20/07/21.
//

import UIKit

class LaunchViewController: UIViewController {
//MARK: Outlets
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        setDarkStatusBar()
    }

    // MARK: navigation
    func pushToSignupScreen(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as? SignupViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }

    func pushToLoginScreen(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
   //MARK: button actions
    @IBAction func signupBtn(_ sender: UIButton) {
        self.pushToSignupScreen()
    }
    
    @IBAction func loginBtn(_ sender: UIButton) {
        self.pushToLoginScreen()
    }
    
}
