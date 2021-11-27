//
//  Buttons.swift
//  GrownStrong
//
//  Created by Aman on 20/07/21.
//

import Foundation
import UIKit

class SignupButton : UIButton{
    
    override func awakeFromNib() {
        self.backgroundColor = AppTheme.defaultGreenColor
        self.layer.cornerRadius = 10
        self.setTitleColor(.black, for: .normal)
    }
}

class LogInButton : UIButton{
    
    override func awakeFromNib() {
        self.backgroundColor = .white
        self.layer.borderWidth = 0
        self.layer.cornerRadius = 10
        self.setTitleColor(.black, for: .normal)

    }
}


class DefaultSubmitButton : UIButton{
    
    override func awakeFromNib() {
        self.backgroundColor = AppTheme.defaultGreenColor
        self.layer.cornerRadius = 20
        self.setTitleColor(.black, for: .normal)
        self.layer.masksToBounds = false
//        self.layer.shadowColor = UIColor.white.cgColor
//        self.layer.shadowOffset =  CGSize.zero    
      //  self.layer.shadowOpacity = 0.5
//        self.layer.shadowRadius = 4
        self.titleLabel?.font = UIFont(name: AppDefaultNames.sansHebrewBold, size: 18)
    }
}

class EditSubmitButton : UIButton{
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.colorFromHex("EE7498")
        self.layer.cornerRadius = 14
        self.setTitleColor(.white, for: .normal)
        self.layer.masksToBounds = false
        self.titleLabel?.font = UIFont(name: AppDefaultNames.SFProRegular, size: 18)
    }
}

class DefaultSkipButton : UIButton{
    
    override func awakeFromNib() {
        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = UIFont(name: AppDefaultNames.SFProRegular, size: 18)
    }
}




class CustomPageControl : UIPageControl{
    override  func awakeFromNib() {
        self.pageIndicatorTintColor = .white
        self.currentPageIndicatorTintColor = AppTheme.defaultGreenColor
    }
    
}
