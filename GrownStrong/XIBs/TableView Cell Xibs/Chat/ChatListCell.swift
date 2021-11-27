//
//  ChatListCell.swift
//  GrownStrong
//
//  Created by Aman on 12/08/21.
//

import UIKit
import Kingfisher

class ChatListCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var profileImg: ProfileImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setUpProfileImg(){
        
    }
    
    func setUserProfileImage(urlStr : String){
        let url = URL(string: urlStr)
        let processor = DownsamplingImageProcessor(size: profileImg.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 20)
        profileImg.kf.indicatorType = .activity
        profileImg.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("_")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
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
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
