//
//  ChallengeCategoriesModel.swift
//  Lauren
//
//  Created by Aman on 18/10/21.
//


import Foundation
import FirebaseFirestore

class ChallengeCategoriesModel : NSObject{
    var id = ""
    var name = ""
    var isSelected = false
    
    init(_ data: [String: Any] ,_ id : String){
        self.id = id
        if let name = data["categoryName"] as? String{
            self.name = name
        }
    }
}


class WorkoutDetailMovementsModel : NSObject{
    var id = ""
    var title = ""
    var isPlayed = false
    var image = ""
    var time = ""
    var videoURL = ""
    
    init(_ data: [String: Any] ,_ id : String){
        self.id = id
        self.title = data["title"] as? String ?? ""
        self.videoURL = data["videoUrl"] as? String ?? ""
        if self.videoURL == ""{
            self.videoURL = data["video"] as? String ?? ""
        }
        self.time = data["time"] as? String ?? ""
        self.image = data["Image"] as? String ?? ""

    }
    
    
}
