//
//  SignupViewController.swift
//  GrownStrong
//
//  Created by Aman on 20/07/21.
//

import UIKit

class SignupViewController: UIViewController {

    //MARK: outlets
    
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var retypePwdTxtFld: UITextField!
    @IBOutlet weak var policyLbl: UILabel!
    @IBOutlet weak var logInBtn: UIButton!
    
    let firebaseControllerHandle  : FIRController = FIRController()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            passwordTxtFld.isSecureTextEntry = true
        retypePwdTxtFld.isSecureTextEntry = true
        
        self.logInBtn.setAttributedText(startingText: "Already have an account?", textColor: .white, font: UIFont(name: AppDefaultNames.sansHebrewRegular, size: 14)!, lastText: "Sign in", secondaryTextColor: UIColor.colorFromHex("EE7498"), secondaryFont: UIFont(name: AppDefaultNames.sansHebrewBold, size: 14)!)

        self.policyLbl.setAttributedText(startingText: "By creating an account you agree to the", textColor: .white, font: UIFont(name: AppDefaultNames.sansHebrewRegular, size: 14)!, lastText: "Terms and Privacy Policy", secondaryTextColor: .white, secondaryFont: UIFont(name: AppDefaultNames.sansHebrewBold, size: 14)!)

        
    }
    
    // MARK: navigation
    func pushToLoginScreen(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    func pushTonNameInfoScreen(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "NameInfoViewController") as? NameInfoViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    
    // MARK: - button actions
    
    @IBAction func submitBtn(_ sender: DefaultSubmitButton) {
//        self.pushTonNameInfoScreen()
//        return
        
        if emailTxtFld.text!.isEmpty{
            displayALertWithTitles(title: AppDefaultNames.name, message: "Please enter your email address", ["Ok"]) { (index) in
                
            }
        }else if emailTxtFld.text!.isValidEmail(emailTxtFld.text!) == false{
            displayALertWithTitles(title: AppDefaultNames.name, message: "Please enter valid email address", ["Ok"]) { (index) in
                
            }
            
        }
        else if passwordTxtFld.text!.isEmpty || retypePwdTxtFld.text!.isEmpty{
            displayALertWithTitles(title: AppDefaultNames.name, message: "Please enter password", ["Ok"]) { (index) in
                
            }
            
        }else if passwordTxtFld.text! != retypePwdTxtFld.text{
            displayALertWithTitles(title: AppDefaultNames.name, message: "Password doesn't match", ["Ok"]) { (index) in
                
            }
        }else{
            Singleton.shared.emailAddress = emailTxtFld.text!
            Singleton.shared.password = passwordTxtFld.text!
            UIApplication.topViewController()?.showLoader()
            firebaseControllerHandle.createAndSaveUser { (userID) in
                print("here is my user id",UserManager.shared.userId as Any)
                self.pushTonNameInfoScreen()
            }
//            self.pushTonNameInfoScreen()
        }
    }

    @IBAction func loginButton(_ sender: UIButton) {
        self.pushToLoginScreen()
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
    
}
