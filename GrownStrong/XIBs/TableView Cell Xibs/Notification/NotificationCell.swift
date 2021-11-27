//
//  NotificationCell.swift
//  GrownStrong
//
//  Created by Aman on 27/08/21.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var profileImgView: ProfileImageView!
    @IBOutlet weak var onlineImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.titleLbl.textAlignment = .left
        // Configure the view for the selected state
    }
    
    func setupDataUI(model: NotificationModel){
        if model.type == NotificationTypes.workoutNotification || model.type == NotificationTypes.challengeNotification{
            var textStr = ""
            
            if model.messageText.contains("earned"){
                textStr = "\(model.messageText) Check your score "
            }else{
                textStr = "\(model.messageText) Check it out "
            }
            
            self.titleLbl.setAttributedText(startingText: textStr, textColor: UIColor.black, font: UIFont(name: AppDefaultNames.sansFontNameRegular, size: 14) ?? UIFont.systemFont(ofSize: 14), lastText: "here:", secondaryTextColor: AppTheme.darkPinkCOlor, secondaryFont: UIFont(name: AppDefaultNames.sansFontNameBold, size: 14) ?? UIFont.boldSystemFont(ofSize: 14))
        }else{
            self.titleLbl.text = model.messageText
        }
        self.timeLbl.text = model.time
        
        if model.type == NotificationTypes.workoutNotification{
            
        }
    }
    
}
