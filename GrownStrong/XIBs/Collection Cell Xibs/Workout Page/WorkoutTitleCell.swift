//
//  WorkoutTitleCell.swift
//  GrownStrong
//
//  Created by Aman on 24/08/21.
//

import UIKit

class WorkoutTitleCell: UICollectionViewCell {

    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var equipmentLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 12
        self.contentView.clipsToBounds = true
    }
    
    
    func setupChallengeData(data : HomeTrendingModel){
        imageView.kf.setImage(with: URL(string: data.image))
        nameLbl.text = data.title
        if UserManager.shared.savedChallengeIDs?.contains(data.id) ?? false{
            saveBtn.setImage(UIImage(named: "savedFullPink"), for: .normal)
        }else{
            saveBtn.setImage(UIImage(named: "whiteSaved"), for: .normal)
        }
    }
    
    func setupWorkoutData(data : HomeTrendingModel){
       
        nameLbl.text = data.title
        equipmentLbl.text = data.equipment.uppercased()
        if data.image != ""{
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: URL(string: data.image))
        }
        if UserManager.shared.savedWorkoutsIDs?.contains(data.id) ?? false{
            saveBtn.setImage(UIImage(named: "savedFullPink"), for: .normal)
        }else{
            saveBtn.setImage(UIImage(named: "whiteSaved"), for: .normal)
        }

    }
    

}
