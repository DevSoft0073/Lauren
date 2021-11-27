//
//  ProfileWorkoutCell.swift
//  GrownStrong
//
//  Created by Aman on 22/07/21.
//

import UIKit

class ProfileWorkoutCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupData(dict: HomeTrendingModel){
            self.titleLbl.text = dict.title
            self.timeLbl.text = dict.time
        if dict.image != ""{
            self.imgView.kf.setImage(with: URL(string: dict.image))
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
