//
//  CurrentWeightViewController.swift
//  Lauren
//
//  Created by Rapidsofts Sahil on 16/11/21.
//

import UIKit

class CurrentWeightViewController: UIViewController {

    //MARK: outlets
    @IBOutlet weak var weightTxtFld: DefaultTextField!
    
    let FIRAuthHandler : FIRController = FIRController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weightTxtFld.text = UserManager.shared.currentWeight
        // Do any additional setup after loading the view.
    }
    

  

    @IBAction func doneBtn(_ sender: DefaultSubmitButton) {
        if self.weightTxtFld.text!.isEmpty{
            displayALertWithTitles(title: "", message: "Please enter your current weight", ["Ok"], completion: nil)
        }else{
            FIRAuthHandler.updateCurrentWeight(weight: weightTxtFld.text!) { (msg) in
                print(msg as Any)
                UserManager.shared.currentWeight = self.weightTxtFld.text!
                UserDefaults.standard.synchronize()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
