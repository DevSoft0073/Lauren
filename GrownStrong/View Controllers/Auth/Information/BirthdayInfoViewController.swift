//
//  BirthdayInfoViewController.swift
//  GrownStrong
//
//  Created by Aman on 20/07/21.
//

import UIKit


class BirthdayInfoViewController: UIViewController {
    //MARK: outlets
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var birthLbl: UILabel!
    @IBOutlet weak var pageControl: CustomPageControl!
    @IBOutlet weak var topHeightConst: NSLayoutConstraint!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.tintColor = AppTheme.defaultGreenColor
        datePicker.setValue(UIColor.white, forKey: "backgroundColor")
        datePicker.addTarget(self, action: #selector(dateChanged(sender:)), for: .valueChanged)
        datePicker.maximumDate = Date()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        if UIDevice.current.screenType == .iPhones_5_5s_5c_SE || UIDevice.current.screenType == .iPhones_6_6s_7_8{
            self.topHeightConst.constant = 8
        }else{
            self.topHeightConst.constant = 60
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.pageControl.currentPage = 5
    }

    @objc func dateChanged(sender:UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
//        formatter.dateStyle = .medium
        self.birthLbl.text = formatter.string(from: datePicker.date)
    }
    
    // MARK: navigation
    func pushToNextVC(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "SkillInfoViewController") as? SkillInfoViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    

    @IBAction func nextBtn(_ sender: DefaultSubmitButton) {
        if self.birthLbl.text == "Enter Birthday"{
            displayALertWithTitles(title: AppDefaultNames.name, message: "Please enter Birthday", ["Ok"], completion: nil)
        }else{
            Singleton.shared.birthday = self.birthLbl.text!
            UserManager.shared.birthday = self.birthLbl.text!
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
