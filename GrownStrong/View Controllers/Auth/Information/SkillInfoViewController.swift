//
//  SkillInfoViewController.swift
//  GrownStrong
//
//  Created by Aman on 20/07/21.
//

import UIKit

enum SkillLevel : String {
    case Beginner = "Beginner"
    case Intermediate = "Intermediate"
    case Pro = "Pro"
}


class SkillInfoViewController: UIViewController {

    //MARK: outlets
    
    @IBOutlet weak var bgnrBtn: UIButton!
    @IBOutlet weak var interBtn: UIButton!
    @IBOutlet weak var proBtn: UIButton!
    @IBOutlet weak var pageControl: CustomPageControl!
    
    let firebaseControllerHandle  : FIRController = FIRController()
    var level = SkillLevel.Beginner.rawValue
    let cornerRadius : CGFloat = 18

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.pageControl.currentPage = 6
    }
    
    //MARK: setup buttons
    func setupUI(){
        self.bgnrBtn.backgroundColor = AppTheme.defaultGreenColor
        self.bgnrBtn.layer.cornerRadius = cornerRadius
        self.interBtn.layer.cornerRadius = cornerRadius
        self.proBtn.layer.cornerRadius = cornerRadius
        self.bgnrBtn.setTitleColor(.black, for: .normal)
        self.interBtn.setTitleColor(.gray, for: .normal)
        self.proBtn.setTitleColor(.gray, for: .normal)
    }
    
    func setupButtons(isBignner:Bool,isIntermidiate:Bool,isPro:Bool){
        if isBignner{
            self.bgnrBtn.setTitleColor(.black, for: .normal)
            self.interBtn.setTitleColor(.gray, for: .normal)
            self.proBtn.setTitleColor(.gray, for: .normal)
            
            self.bgnrBtn.backgroundColor = AppTheme.defaultGreenColor
            self.interBtn.backgroundColor = .clear
            self.proBtn.backgroundColor = .clear
            self.level = SkillLevel.Beginner.rawValue

        }else if isIntermidiate{
            self.bgnrBtn.setTitleColor(.gray, for: .normal)
            self.interBtn.setTitleColor(.black, for: .normal)
            self.proBtn.setTitleColor(.gray, for: .normal)
            
            self.bgnrBtn.backgroundColor = .clear
            self.interBtn.backgroundColor = AppTheme.defaultGreenColor
            self.proBtn.backgroundColor = .clear
            self.level = SkillLevel.Intermediate.rawValue


        }else if isPro{
            self.bgnrBtn.setTitleColor(.gray, for: .normal)
            self.interBtn.setTitleColor(.gray, for: .normal)
            self.proBtn.setTitleColor(.black, for: .normal)
            
            self.bgnrBtn.backgroundColor = .clear
            self.interBtn.backgroundColor = .clear
            self.proBtn.backgroundColor = AppTheme.defaultGreenColor
            self.level = SkillLevel.Pro.rawValue

        }
    }
    
    // MARK: navigation
    func pushToNextVC(){
//        let vc = storyboard?.instantiateViewController(withIdentifier: "SideMenuController") as? SideMenuController
//        self.navigationController?.pushViewController(vc!, animated: true)
        let vc = storyboard?.instantiateViewController(withIdentifier: "WeightInfoViewController") as? WeightInfoViewController
        self.navigationController?.pushViewController(vc!, animated: true)

    }
    
    //MARK: button actions
    @IBAction func beginrBtn(_ sender: UIButton) {
        self.setupButtons(isBignner: true, isIntermidiate: false, isPro: false)
    }
    @IBAction func interBtn(_ sender: UIButton) {
        self.setupButtons(isBignner: false, isIntermidiate: true, isPro: false)
    }
    @IBAction func proBtn(_ sender: UIButton) {
        self.setupButtons(isBignner: false, isIntermidiate: false, isPro: true)
    }
    
    @IBAction func nextBtn(_ sender: DefaultSubmitButton) {
        Singleton.shared.skillLevel = level
        self.pushToNextVC()
        
//        UserManager.shared.clear()
//        firebaseControllerHandle.createUser { (userID) in
//            print("here is current user id",userID ?? "")
//            self.pushToNextVC()
//        }
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func skipBtn(_ sender: UIButton) {
        self.pushToNextVC()
    }
    

}
