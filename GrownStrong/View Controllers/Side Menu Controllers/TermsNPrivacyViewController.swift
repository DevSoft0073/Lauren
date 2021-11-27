//
//  TermsNPrivacyViewController.swift
//  GrownStrong
//
//  Created by Aman on 30/07/21.
//

import UIKit

class TermsNPrivacyViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    var isTermsPage = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isTermsPage{
            self.titleLbl.text = "Terms of Service"
        }else{
            self.titleLbl.text = "Privacy Policy"

        }
        
    }
    

    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
