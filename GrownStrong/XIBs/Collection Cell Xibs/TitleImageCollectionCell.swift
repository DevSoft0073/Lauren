//
//  TitleImageCollectionCell.swift
//  GrownStrong
//
//  Created by Aman on 20/07/21.
//

import UIKit

class TitleImageCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lineView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.contentView.layer.cornerRadius = 20
        self.contentView.clipsToBounds = true
        self.lineView.borderWidth = 2
        self.lineView.borderColor = UIColor.colorFromHex("EE7498")
    }

}
