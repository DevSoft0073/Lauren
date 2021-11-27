//
//  GenderInfoViewController.swift
//  GrownStrong
//
//  Created by Aman on 20/07/21.
//

import UIKit

class GenderInfoViewController: UIViewController {
    //MARK: outlets
    
    @IBOutlet weak var pageControl: CustomPageControl!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var otherBtn: UIButton!
    
    var gender = "Male"
    let cornerRadius : CGFloat = 18
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.gender = "Male"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.pageControl.currentPage = 2
    }

    //MARK: setup buttons
    func setupUI(){
        self.maleBtn.backgroundColor = AppTheme.defaultGreenColor
        self.maleBtn.layer.cornerRadius = cornerRadius
        self.femaleBtn.layer.cornerRadius = cornerRadius
        self.otherBtn.layer.cornerRadius = cornerRadius
        self.maleBtn.setTitleColor(.black, for: .normal)
        self.femaleBtn.setTitleColor(.gray, for: .normal)
        self.otherBtn.setTitleColor(.gray, for: .normal)
    }
    
    func setupButtons(isMale:Bool,isFemale:Bool,isOther:Bool){
        
        if isMale{
            self.maleBtn.setTitleColor(.black, for: .normal)
            self.femaleBtn.setTitleColor(.gray, for: .normal)
            self.otherBtn.setTitleColor(.gray, for: .normal)
            
            self.maleBtn.backgroundColor = AppTheme.defaultGreenColor
            self.femaleBtn.backgroundColor = .clear
            self.otherBtn.backgroundColor = .clear
            self.gender = "Male"

        }else if isFemale{
            self.maleBtn.setTitleColor(.gray, for: .normal)
            self.femaleBtn.setTitleColor(.black, for: .normal)
            self.otherBtn.setTitleColor(.gray, for: .normal)
            
            self.maleBtn.backgroundColor = .clear
            self.femaleBtn.backgroundColor = AppTheme.defaultGreenColor
            self.otherBtn.backgroundColor = .clear
            self.gender = "Female"


        }else if isOther{
            self.maleBtn.setTitleColor(.gray, for: .normal)
            self.femaleBtn.setTitleColor(.gray, for: .normal)
            self.otherBtn.setTitleColor(.black, for: .normal)
            
            self.maleBtn.backgroundColor = .clear
            self.femaleBtn.backgroundColor = .clear
            self.otherBtn.backgroundColor = AppTheme.defaultGreenColor
            self.gender = "Other"

        }
    }
    
    
    // MARK: navigation
    func pushToNextVC(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "LocationInfoViewController") as? LocationInfoViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    // MARK: - Button action
    
    @IBAction func skipBtn(_ sender: UIButton) {
        self.pushToNextVC()
    }
    
    @IBAction func nextBtn(_ sender: DefaultSubmitButton) {
        Singleton.shared.gender = self.gender
        UserManager.shared.gender = self.gender
        self.pushToNextVC()
    }
    
    @IBAction func otherBtn(_ sender: UIButton) {
        self.setupButtons(isMale: false, isFemale: false, isOther: true)
    }
    
    @IBAction func maleBtn(_ sender: UIButton) {
        self.setupButtons(isMale: true, isFemale: false, isOther: false)
    }
    @IBAction func femaleBtn(_ sender: UIButton) {
        self.setupButtons(isMale: false, isFemale: true, isOther: false)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
