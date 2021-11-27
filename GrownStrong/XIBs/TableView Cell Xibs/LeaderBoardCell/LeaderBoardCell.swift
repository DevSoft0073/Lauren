//
//  LeaderBoardCell.swift
//  Lauren
//
//  Created by Aman on 24/09/21.
//

import UIKit

class LeaderBoardCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var serialLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setDataInCell(data:HomeTrendingModel,serial:String){
        self.nameLbl.text = data.title
        self.pointsLbl.text = "\(data.points) PTS"
        self.serialLbl.text = serial
    }
    
}
