//
//  NameInfoViewController.swift
//  GrownStrong
//
//  Created by Aman on 20/07/21.
//

import UIKit

class NameInfoViewController: UIViewController {

    //MARK: outlets
    @IBOutlet weak var nameTxtFld: UITextField!
    @IBOutlet weak var pageControl: CustomPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.pageControl.currentPage = 0
    }
    
    
  
    
    // MARK: navigation
    func pushToNextVC(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileImageInfoViewController") as? ProfileImageInfoViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
  
    
    @IBAction func nexytBtn(_ sender: DefaultSubmitButton) {
        if nameTxtFld.text!.isEmpty{
            displayALertWithTitles(title: AppDefaultNames.name, message: "Please enter name", ["Ok"]) { (index) in
                
            }
        }else{
            Singleton.shared.name = nameTxtFld.text!
            UserManager.shared.fullName = nameTxtFld.text!
            self.pushToNextVC()
        }
       
    }
    @IBAction func skipBtn(_ sender: UIButton) {
        self.pushToNextVC()
    }
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
