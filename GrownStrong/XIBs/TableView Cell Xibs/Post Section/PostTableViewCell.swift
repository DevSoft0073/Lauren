//
//  PostTableViewCell.swift
//  GrownStrong
//
//  Created by Aman on 19/08/21.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImg: ProfileImageView!
    @IBOutlet weak var onlineDotImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var videoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var videoImgView: UIImageView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var decriptionLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var heartCountLbl: UILabel!
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var heartImg: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.profileImg.contentMode = .scaleAspectFill
    }
    

    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
