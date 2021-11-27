//
//  TitleImageOptionsCell.swift
//  GrownStrong
//
//  Created by Aman on 02/08/21.
//

import UIKit

class TitleImageOptionsCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.layer.cornerRadius = 20
        self.contentView.clipsToBounds = true

    }

}
