//
//  CustomTabViewController.swift
//  GrownStrong
//
//  Created by Aman on 20/07/21.
//

import UIKit
import LGSideMenuController
import FirebaseMessaging

class CustomTabViewController: UITabBarController,UITabBarControllerDelegate,UIGestureRecognizerDelegate, UIViewControllerTransitioningDelegate {
    
    let firebaseControllerHandle  : FIRController = FIRController()
    var transition: BubbleTransition?
    var interactiveTransition: BubbleInteractiveTransition?
    var centerButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isTranslucent = false
        self.tabBar.barTintColor = .black
        self.tabBar.unselectedItemTintColor = .lightGray
        self.tabBar.tintColor = AppTheme.defaultGreenColor
        self.tabBar.itemWidth = 80
        self.delegate = self
        self.transition = BubbleTransition()
        self.interactiveTransition = BubbleInteractiveTransition()
        //        self.tabBar.backgroundImage = UIImage(named: "laurenBlackBG")
        self.tabBar.barStyle = .black
        
        
        self.tabBar.invalidateIntrinsicContentSize()
        self.view.autoresizingMask = .flexibleHeight
        self.view.setNeedsLayout()
        if let newButtonImage = UIImage(named: "CenterButton") {
            self.addCenterButton(withImage: newButtonImage, highlightImage: newButtonImage)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Messaging.messaging().token { (str, err) in
                if err == nil{
                    print("here is token:",str as Any)
                    self.firebaseControllerHandle.updateToken(token: str ?? "") { (msg) in
                        print(msg ?? "")
                    }
                }
            }
        }
        
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tabBar.invalidateIntrinsicContentSize()
        //        print(UIDevice.current.screenType)
        //        if UIDevice.current.userInterfaceIdiom == .phone && (UIScreen.main.nativeBounds.size.height >= 2778 || UIScreen.main.nativeBounds.size.height >= 2532) {
        //            var tabFrame = tabBar.frame
        //            tabFrame.size.height = 90
        //            tabFrame.origin.y = view.frame.size.height - 90
        //            tabBar.frame = tabFrame
        //        }
        
        print(UIDevice.current.screenType)
        
        if UIDevice.current.screenType == .iPhones_5_5s_5c_SE || UIDevice.current.screenType == .iPhones_6_6s_7_8 {
            tabBar.frame.size.height = 60
            tabBar.frame.origin.y = view.frame.height - 60
            
        }else if UIDevice.current.screenType == .iPhoneXSMax {
            tabBar.frame.size.height = 120
            tabBar.frame.origin.y = view.frame.height - 120
        }
        else {
            tabBar.frame.size.height = 100
            tabBar.frame.origin.y = view.frame.height - 100
            
        }
        
        let tabBarItem1 = tabBar.items?[0]
        let tabBarItem2 = tabBar.items?[1]
        let tabBarItem3 = tabBar.items?[2]
        let tabBarItem4 = tabBar.items?[3]
        let tabBarItem5 = tabBar.items?[4]
        tabBarItem3?.isEnabled = false
        
        tabBarItem1?.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -6)
        tabBarItem2?.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -6)
        tabBarItem3?.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -6)
        tabBarItem4?.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -6)
        tabBarItem5?.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -6)
        
    }
    
    //MARK: open side menu
    func openSideMenu(){
        sideMenuController?.showLeftViewAnimated(sender: self)
    }
    
    
    @objc func centerBtnTapped(_ sender: UIButton){
        print("center btn tapped")
//        self.selectedIndex = 2
  
        self.performSegue(withIdentifier: "showDailyWorkout", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let naviCon = segue.destination as! UINavigationController
        let vc = naviCon.viewControllers[0] as? DailyWorkoutViewController
        
        vc?.view.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            vc?.view.hideAndShowWithAnim(forHide: false)
        }
        naviCon.transitioningDelegate = self
        naviCon.modalPresentationStyle = .custom
        vc?.interactiveTransition = self.interactiveTransition
        DispatchQueue.main.async {
            self.interactiveTransition?.attach(to: naviCon)
        }
        
    }
   
    
    func addCenterButton(withImage buttonImage : UIImage, highlightImage: UIImage) {        
        centerButton = UIButton(type: .custom)
        centerButton.setBackgroundImage(buttonImage, for: .normal)
        centerButton.setBackgroundImage(buttonImage, for: .highlighted)
        let customTabbar = tabBar as? TXTabBar
        customTabbar?.centerButton = centerButton
        
        tabBar.addSubview(centerButton)
        centerButton.translatesAutoresizingMaskIntoConstraints = false
        centerButton.centerYAnchor.constraint(equalTo: tabBar.topAnchor, constant: -8).isActive = true
        centerButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor).isActive = true
        centerButton.addTarget(self, action: #selector(centerBtnTapped(_:)), for: .touchUpInside)
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 2{
            self.performSegue(withIdentifier: "showDailyWorkout", sender: nil)
        }else{
            viewController.viewWillAppear(true)
        }
    }
   
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return otherGestureRecognizer is UIScreenEdgePanGestureRecognizer
    }
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transition?.transitionMode = .dismiss
        self.transition?.startingPoint = self.tabBar.center;
        self.transition?.bubbleColor = AppTheme.darkPinkCOlor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIApplication.topViewController()?.hideLoader()
        }
        return self.transition;
        
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transition?.transitionMode = .present
//        self.transition?.startingPoint = self.tabBar.center;
        self.transition?.startingPoint = self.tabBar.center;

        self.transition?.bubbleColor = AppTheme.darkPinkCOlor
        UIApplication.topViewController()?.hideLoader()
        return self.transition;
        
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactiveTransition
    }
}



