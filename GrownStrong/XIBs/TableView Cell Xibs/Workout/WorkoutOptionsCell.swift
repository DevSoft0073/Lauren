//
//  WorkoutOptionsCell.swift
//  GrownStrong
//
//  Created by Aman on 28/07/21.
//

import UIKit

class WorkoutOptionsCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var imageWidthConst: NSLayoutConstraint!
    @IBOutlet weak var optionBtn: UIImageView!
    
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgView.contentMode = .scaleAspectFill
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
