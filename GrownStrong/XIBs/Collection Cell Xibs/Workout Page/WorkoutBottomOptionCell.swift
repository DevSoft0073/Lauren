//
//  WorkoutBottomOptionCell.swift
//  GrownStrong
//
//  Created by Aman on 24/08/21.
//

import UIKit

class WorkoutBottomOptionCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var equipmentLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.saveBtn.defaultShaddow()
    }

    
    func setupCellData(data : HomeTrendingModel){
        titleLbl.text = data.title
        imgView.kf.setImage(with: URL(string: data.image))
        timeLbl.text = data.time
        equipmentLbl.text = data.equipment
        if UserManager.shared.savedWorkoutsIDs?.contains(data.id) ?? false{
            saveBtn.setImage(UIImage(named: "savedFullPink"), for: .normal)
        }else{
            saveBtn.setImage(UIImage(named: "whiteSaved"), for: .normal)
        }

    }
    
}
