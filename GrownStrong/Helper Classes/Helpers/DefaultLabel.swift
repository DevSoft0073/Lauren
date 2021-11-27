//
//  DefaultLabel.swift
//  GrownStrong
//
//  Created by Aman on 02/08/21.
//

import Foundation
import UIKit


class DefaultLabelOpenSans :UILabel {
    
    override  func awakeFromNib() {
        self.font = UIFont(name: AppDefaultNames.sansHebrewRegular, size: 16)
    }
}

class DefaultLabelBison :UILabel {
    
    override  func awakeFromNib() {
        self.font = UIFont(name: AppDefaultNames.bisonFont, size: 22)
        self.text?.uppercased()
        
    }
}

class roundLabel : UILabel{
    override  func awakeFromNib() {
        self.layer.cornerRadius = self.frame.width/2
        self.layer.masksToBounds = true
    }
}
