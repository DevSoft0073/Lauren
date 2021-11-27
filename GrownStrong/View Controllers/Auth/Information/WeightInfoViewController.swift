//
//  WeightInfoViewController.swift
//  Lauren
//
//  Created by Rapidsofts Sahil on 11/11/21.
//

import UIKit

class WeightInfoViewController: UIViewController {

    //MARK: outlets
    @IBOutlet weak var currentWeightFld: DefaultTextField!
    @IBOutlet weak var goalWeightFld: DefaultTextField!
    
    let firebaseControllerHandle  : FIRController = FIRController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    //MARK: button actions
    @IBAction func doneBtn(_ sender: DefaultSubmitButton) {
        
        if currentWeightFld.text!.isEmpty{
            displayALertWithTitles(title: AppDefaultNames.name, message: "Please enter your current weight", ["Ok"]) { (index) in
                
            }
        }else if goalWeightFld.text!.isEmpty{
            displayALertWithTitles(title: AppDefaultNames.name, message: "Please enter goal weight", ["Ok"]) { (index) in
                
            }
            
        }else{
            UserManager.shared.currentWeight = currentWeightFld.text!
            UserManager.shared.goalWeight = goalWeightFld.text!
            if UserManager.shared.userId == nil || UserManager.shared.userId == ""{
                return
            }
            UIApplication.topViewController()?.showLoader()
            firebaseControllerHandle.saveInfoInFirestore(currentUserID: UserManager.shared.userId!) { (msg) in
                print(msg as Any)
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController{
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
       
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
