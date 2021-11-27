//
//  LoginViewController.swift
//  GrownStrong
//
//  Created by Aman on 20/07/21.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {

    //MARK: outlets
    
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var forgotBtn: UIButton!
    
    let firebaseControllerHandle  : FIRController = FIRController()
    var isVisible = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordTxtFld.delegate = self
        self.passwordTxtFld.isSecureTextEntry = true
        //Don’t have an account? Create account
        
        self.signUpBtn.setAttributedText(startingText: "Don’t have an account?", textColor: .white, font: UIFont(name: AppDefaultNames.sansHebrewRegular, size: 14)!, lastText: "Create account", secondaryTextColor: UIColor.colorFromHex("EE7498"), secondaryFont: UIFont(name: AppDefaultNames.sansHebrewBold, size: 14)!)
        self.forgotBtn.setTitleColor(UIColor.colorFromHex("EE7498"), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.isVisible = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.isVisible = false
    }
    
    // MARK: navigation
    func pushToSignupScreen(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as? SignupViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func pushToHomePage(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "SideMenuController") as? SideMenuController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func testPagePush(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileImageInfoViewController") as? ProfileImageInfoViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
 
    
    //MARK: login firebase
    func loginAuth(){
        if emailTxtFld.text!.isEmpty {
            displayALertWithTitles(title: AppDefaultNames.name, message: "Please enter email address", ["Ok"], completion: nil)
        } else if emailTxtFld.text!.isValidEmail(emailTxtFld.text!) == false {
            displayALertWithTitles(title: AppDefaultNames.name, message: "Please enter valid email address", ["Ok"], completion: nil)
        }else if passwordTxtFld.text!.isEmpty{
            displayALertWithTitles(title: AppDefaultNames.name, message: "Please enter password", ["Ok"], completion: nil)
        }else{
            firebaseControllerHandle.loginUser(emailTxtFld.text, password: passwordTxtFld.text!) { (userId) in
               // print("here is login user id",userId ?? "")
                if self.isVisible{
                    self.pushToHomePage()
                }
            }
        }
    }
    
    
    @IBAction func forgotBtn(_ sender: UIButton) {
        if emailTxtFld.text!.isEmpty {
            displayALertWithTitles(title: AppDefaultNames.name, message: "Please enter email address", ["Ok"], completion: nil)
        } else if emailTxtFld.text!.isValidEmail(emailTxtFld.text!) == false {
            displayALertWithTitles(title: AppDefaultNames.name, message: "Please enter valid email address", ["Ok"], completion: nil)
        }else{
            firebaseControllerHandle.resetPassword(email: emailTxtFld.text!) { (msg) in
                displayALertWithTitles(title: AppDefaultNames.name, message: msg ?? "", ["Ok"], completion: nil)
            }
        }
        
    }
    //MARK: Button actions
    @IBAction func submitBtn(_ sender: DefaultSubmitButton) {
//        self.pushToHomePage()

        self.loginAuth()
//        self.testPagePush()
//        self.pushToNameInfoVC()
    }
    
    @IBAction func signupBtn(_ sender: UIButton) {
        self.pushToSignupScreen()
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension LoginViewController{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.forgotBtn.isHidden = true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.forgotBtn.isHidden = false
    }
    
}
