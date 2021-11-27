//
//  WorkOutInfoViewController.swift
//  GrownStrong
//
//  Created by Aman on 20/07/21.
//

import UIKit

enum Place : String {
    case home = "Home"
    case gym = "Gym"
    case outside = "Outside"
}

class WorkOutInfoViewController: UIViewController {

    //MARK: outlets
    
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var gymButton: UIButton!
    @IBOutlet weak var outsideBtn: UIButton!
    @IBOutlet weak var pageControl: CustomPageControl!
    
    var workoutPlace = Place.home.rawValue
    let cornerRadius : CGFloat = 18

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.pageControl.currentPage = 4
    }

    //MARK: setup buttons
    func setupUI(){
        self.homeButton.backgroundColor = AppTheme.defaultGreenColor
        self.homeButton.layer.cornerRadius = cornerRadius
        self.gymButton.layer.cornerRadius = cornerRadius
        self.outsideBtn.layer.cornerRadius = cornerRadius
        self.homeButton.setTitleColor(.black, for: .normal)
        self.gymButton.setTitleColor(.gray, for: .normal)
        self.outsideBtn.setTitleColor(.gray, for: .normal)
    }
    
    func setupButtons(isHome:Bool,isGym:Bool,isOutside:Bool){
        if isHome{
            self.homeButton.setTitleColor(.black, for: .normal)
            self.gymButton.setTitleColor(.gray, for: .normal)
            self.outsideBtn.setTitleColor(.gray, for: .normal)
            
            self.homeButton.backgroundColor = AppTheme.defaultGreenColor
            self.gymButton.backgroundColor = .clear
            self.outsideBtn.backgroundColor = .clear
            self.workoutPlace = Place.home.rawValue

        }else if isGym{
            self.homeButton.setTitleColor(.gray, for: .normal)
            self.gymButton.setTitleColor(.black, for: .normal)
            self.outsideBtn.setTitleColor(.gray, for: .normal)
            
            self.homeButton.backgroundColor = .clear
            self.gymButton.backgroundColor = AppTheme.defaultGreenColor
            self.outsideBtn.backgroundColor = .clear
            self.workoutPlace = Place.gym.rawValue


        }else if isOutside{
            self.homeButton.setTitleColor(.gray, for: .normal)
            self.gymButton.setTitleColor(.gray, for: .normal)
            self.outsideBtn.setTitleColor(.black, for: .normal)
            
            self.homeButton.backgroundColor = .clear
            self.gymButton.backgroundColor = .clear
            self.outsideBtn.backgroundColor = AppTheme.defaultGreenColor
            self.workoutPlace = Place.outside.rawValue

        }
    }
    
    // MARK: navigation
    func pushToNextVC(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "BirthdayInfoViewController") as? BirthdayInfoViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    
    // MARK: - Button actions
    @IBAction func homeBtn(_ sender: UIButton) {
        self.setupButtons(isHome: true, isGym: false, isOutside: false)
    }
    
    @IBAction func outsideBtn(_ sender: UIButton) {
        self.setupButtons(isHome: false, isGym: false, isOutside: true)
    }
    
    @IBAction func gymBtn(_ sender: UIButton) {
        self.setupButtons(isHome: false, isGym: true, isOutside: false)
    }
    
    @IBAction func nextBtn(_ sender: DefaultSubmitButton) {
        Singleton.shared.workoutPlace = self.workoutPlace
        UserManager.shared.workoutPlace = self.workoutPlace
        self.pushToNextVC()
    }
    
    @IBAction func skipBtn(_ sender: UIButton) {
        self.pushToNextVC()
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
