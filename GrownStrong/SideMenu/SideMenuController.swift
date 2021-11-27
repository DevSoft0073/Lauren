//
//  SideMenuController.swift
//  GrownStrong
//
//  Created by Aman on 22/07/21.
//

import Foundation
import UIKit
import LGSideMenuController


class SideMenuController: LGSideMenuController , LGSideMenuDelegate {
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftViewWidth = self.view.frame.size.width - 100.0
        sideMenuController?.delegate = self;
//        self.navigationController?.navigationBar.isHidden = true
        isLeftViewStatusBarBackgroundHidden = false
    }


   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func didShowLeftView(_ leftView: UIView, sideMenuController: LGSideMenuController) {
        
    }

    //delegates
    func willShowLeftView(sideMenuController: LGSideMenuController) {
        //
        setDarkStatusBar()
    }
    
    func didShowLeftView(sideMenuController: LGSideMenuController) {
        //
    }
    
    func willHideLeftView(sideMenuController: LGSideMenuController) {
        //
        setLightStatusBar()
    }
    
    func didHideLeftView(sideMenuController: LGSideMenuController) {
        //
    }
    
    func willShowRightView(sideMenuController: LGSideMenuController) {
        //
    }
    
    func didShowRightView(sideMenuController: LGSideMenuController) {
        //
    }
    
    func willHideRightView(sideMenuController: LGSideMenuController) {
        //
    }
    
    func didHideRightView(sideMenuController: LGSideMenuController) {
        //
    }
    
    func showAnimationsForLeftView(sideMenuController: LGSideMenuController, duration: TimeInterval, timingFunction: CAMediaTimingFunction) {
        //
    }
    
    func hideAnimationsForLeftView(sideMenuController: LGSideMenuController, duration: TimeInterval, timingFunction: CAMediaTimingFunction) {
        //
    }
    
    func showAnimationsForRightView(sideMenuController: LGSideMenuController, duration: TimeInterval, timingFunction: CAMediaTimingFunction) {
        //
    }
    
    func hideAnimationsForRightView(sideMenuController: LGSideMenuController, duration: TimeInterval, timingFunction: CAMediaTimingFunction) {
        //
    }
    
    func didTransformRootView(sideMenuController: LGSideMenuController, percentage: CGFloat) {
        //
    }
    
    func didTransformLeftView(sideMenuController: LGSideMenuController, percentage: CGFloat) {
        //
    }
    
    func didTransformRightView(sideMenuController: LGSideMenuController, percentage: CGFloat) {
        //
    }
    
}
