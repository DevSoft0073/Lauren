//
//  LibrarySelectionCell.swift
//  GrownStrong
//
//  Created by Aman on 24/08/21.
//

import UIKit

class LibrarySelectionCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setTitleBG(isSelected:Bool,title: String){
        self.titleLbl.text = title
        if isSelected{
            self.backView.backgroundColor = AppTheme.darkPinkCOlor
            self.titleLbl.textColor = .white
            self.titleLbl.font = UIFont(name: AppDefaultNames.sansHebrewBold, size: 15)
        }else{
            self.backView.backgroundColor = UIColor.colorFromHex("DEDEDE").withAlphaComponent(0.5)
            self.titleLbl.textColor = .black
            self.titleLbl.font = UIFont(name: AppDefaultNames.sansHebrewRegular, size: 15)

        }
    }
    
}
