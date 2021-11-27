//
//  PostCommentCell.swift
//  GrownStrong
//
//  Created by Aman on 23/08/21.
//

import UIKit

class PostCommentCell: UITableViewCell {

    @IBOutlet weak var userProfileImgview: ProfileImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.userProfileImgview.contentMode = .scaleAspectFill

    }

    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func imageWith(name: String?) -> UIImage? {
            let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            let nameLabel = UILabel(frame: frame)
            nameLabel.textAlignment = .center
            nameLabel.backgroundColor = .lightGray
            nameLabel.textColor = .white
            nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
            var initials = ""
            if let initialsArray = name?.components(separatedBy: " ") {
                if let firstWord = initialsArray.first {
                    if let firstLetter = firstWord.first {
                        initials += String(firstLetter).capitalized }
                }
                if initialsArray.count > 1, let lastWord = initialsArray.last {
                    if let lastLetter = lastWord.first { initials += String(lastLetter).capitalized
                    }
                }
            } else {
                return nil
            }
            nameLabel.text = initials
            UIGraphicsBeginImageContext(frame.size)
            if let currentContext = UIGraphicsGetCurrentContext() {
                nameLabel.layer.render(in: currentContext)
                let nameImage = UIGraphicsGetImageFromCurrentImageContext()
                return nameImage
            }
            return nil
        }
}
