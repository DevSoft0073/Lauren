//
//  LeftMenuViewController.swift
//  GrownStrong
//
//  Created by Aman on 22/07/21.
//

import UIKit

class LeftMenuViewController: UIViewController {
    
    @IBOutlet weak var sideTblView: UITableView!
    
    let firebaseHandler : FIRController = FIRController()
    
    let titleArray = ["Settings","About","Profile","Support","Terms","Privacy","Current Weight","Log Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideTblView.separatorStyle = .none
    }
    
  
    
    //MARK: navigation
    func pushToSettingPage(){
        let vc =  storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        vc.hidesBottomBarWhenPushed = true
        ((sideMenuController?.rootViewController as! UITabBarController).selectedViewController as! UINavigationController).pushViewController(vc, animated: true)
        
        sideMenuController?.hideLeftView(animated: true, completion: nil)
        
    }
    func pushToSubscriptionPage(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "SubscriptionViewController") as! SubscriptionViewController
        vc.hidesBottomBarWhenPushed = true
        ((sideMenuController?.rootViewController as! UITabBarController).selectedViewController as! UINavigationController).pushViewController(vc, animated: true)
        sideMenuController?.hideLeftView(animated: true, completion: nil)
        
    }
    func pushToSupportPage(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "SupportViewController") as! SupportViewController
        vc.hidesBottomBarWhenPushed = true
        ((sideMenuController?.rootViewController as! UITabBarController).selectedViewController as! UINavigationController).pushViewController(vc, animated: true)
        sideMenuController?.hideLeftView(animated: true, completion: nil)
        
    }
    func pushToAboutPage(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
        vc.hidesBottomBarWhenPushed = true
        ((sideMenuController?.rootViewController as! UITabBarController).selectedViewController as! UINavigationController).pushViewController(vc, animated: true)
        sideMenuController?.hideLeftView(animated: true, completion: nil)
        
//        let vc = storyboard?.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
//        vc.hidesBottomBarWhenPushed = true
//        ((sideMenuController?.rootViewController as! UITabBarController).selectedViewController as! UINavigationController).pushViewController(vc, animated: true)
//        sideMenuController?.hideLeftView(animated: true, completion: nil)
        
    }
    func pushToTermNPrivacyPage(isTerms: Bool){
        let vc = storyboard?.instantiateViewController(withIdentifier: "TermsNPrivacyViewController") as! TermsNPrivacyViewController
        vc.hidesBottomBarWhenPushed = true
        vc.isTermsPage = isTerms
        ((sideMenuController?.rootViewController as! UITabBarController).selectedViewController as! UINavigationController).pushViewController(vc, animated: true)
        sideMenuController?.hideLeftView(animated: true, completion: nil)
        
    }
    
   
    func pushToProfileVC(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        vc.hidesBottomBarWhenPushed = true
        ((sideMenuController?.rootViewController as! UITabBarController).selectedViewController as! UINavigationController).pushViewController(vc, animated: true)
        sideMenuController?.hideLeftView(animated: true, completion: nil)
    }
    
    func pushToCurrenWeightVC(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "CurrentWeightViewController") as! CurrentWeightViewController
        vc.hidesBottomBarWhenPushed = true
        ((sideMenuController?.rootViewController as! UITabBarController).selectedViewController as! UINavigationController).pushViewController(vc, animated: true)
        sideMenuController?.hideLeftView(animated: true, completion: nil)
    }
}

extension LeftMenuViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideCustomCell") as? SideCustomCell
        cell?.nameLbl.text = titleArray[indexPath.row]
        if indexPath.row == titleArray.count - 1{
            cell?.nameLbl.font = UIFont(name: AppDefaultNames.sansFontNameBold, size: 17)
        }else{
            cell?.nameLbl.font = UIFont(name: AppDefaultNames.sansFontNameRegular, size: 17)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == titleArray.count - 1{
//            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = mainStoryboard.instantiateViewController(withIdentifier: "LaunchViewController") as? LaunchViewController
//            let nav = UINavigationController(rootViewController: vc!)
//            nav.navigationBar.isHidden = true
//            appDelegate().window?.rootViewController = nav

            displayALertWithTitles(title: AppDefaultNames.name, message: "Are you sure want to logout?", ["Logout","Cancel"]) { (index) in
                if index == 0{
                    self.firebaseHandler.logout()
                }
            }
        }else{

            switch indexPath.row{
            case 0:
                self.pushToSettingPage()
            case 1:
                self.pushToAboutPage()
            case 2:
                //self.pushToSupportPage()
            print("profile")
                self.pushToProfileVC()
            case 3:
                self.pushToSupportPage()
            case 4:
                self.pushToTermNPrivacyPage(isTerms: true)
            case 5:
                self.pushToTermNPrivacyPage(isTerms: false)
            case 6:
                self.pushToCurrenWeightVC()
                
            default:
                print("none")
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
}

//MARK: custom side table
class SideCustomCell : UITableViewCell{
    //MARK: outlets
    @IBOutlet weak var nameLbl: UILabel!
    
    override  func awakeFromNib() {
        self.selectionStyle = .none
    }
}
