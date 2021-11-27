//
//  WorkoutBottomBar.swift
//  GrownStrong
//
//  Created by Aman on 28/07/21.
//

import UIKit

class WorkoutBottomBar: UIView {

    @IBOutlet weak var workoutBtn: UIButton!
    
    
    typealias completionBlock = (Int)->()
     var doneClick : completionBlock!
    
    override  func awakeFromNib() {
        self.workoutBtn.defaultShaddow()
    }
 
    
    func doneAction(completion : @escaping completionBlock) {
      doneClick = completion
    }
    
    @IBAction func workOutBtn(_ sender: UIButton) {
        doneClick(1)
    }
    
    
    func addBottomBar(view : UIView){
        
        self.frame = view.frame
        let height = view.frame.size.height
        self.layer.cornerRadius = 20
        self.frame = CGRect(x: 0, y: height - 150 , width: view.frame.width, height: 60)
        view.addSubview(self)
        self.backgroundColor = .clear
       
        self.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self , attribute: .leading, multiplier: 1, constant: -8)
        view.addConstraint(leadingConstraint)
        let trailingConstraint = NSLayoutConstraint(item: view , attribute: .trailing, relatedBy: .equal, toItem: self , attribute: .trailing, multiplier: 1, constant: 8)
        
        view.addConstraint(trailingConstraint)
        
        if #available(iOS 11.0, *) {
            self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32).isActive = true
        } else {
            let bottomConstraint = NSLayoutConstraint(item: view , attribute: .bottom, relatedBy: .equal, toItem: self , attribute: .bottom, multiplier: 1, constant: 32)
            view.addConstraint(bottomConstraint)
        }
        self.heightAnchor.constraint(equalToConstant: 65).isActive = true

    }

}
