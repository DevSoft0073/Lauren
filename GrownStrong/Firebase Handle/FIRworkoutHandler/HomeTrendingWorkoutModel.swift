//
//  HomeTrendingWorkoutModel.swift
//  GrownStrong
//
//  Created by Aman on 31/08/21.
//

import Foundation
import FirebaseFirestore

class HomeTrendingModel :NSObject{ //main wokout model
    var title = ""
    var time = ""
    var id = ""
    var type = ""
    var image = ""
    var descriptionText = ""
    var videoUrl = ""
    var points = 0
    var isAlreadySaved = false
    
    var savedByArray = [String]()
    
    var timeStamp = Timestamp()
    var calories = ""
    var equipment = ""
    var isCompleted = false
    
    
    init(_ data : [String: Any], workoutID : String){
        self.title = data["Title"] as? String ?? ""
        self.time = data["Time"] as? String ?? ""
        self.points = data["Points"] as? Int ?? 0
        self.id = workoutID
        self.type = data["Type"] as? String ?? ""
        self.image = data["Image"] as? String ?? ""
        self.descriptionText = data["description"] as? String ?? ""
        if self.descriptionText == ""{
            self.descriptionText = data["Description"] as? String ?? ""
        }
        self.videoUrl = data["videoUrl"] as? String ?? ""
        self.calories = data["calories"] as? String ?? ""
        self.equipment = data["equipment"] as? String ?? ""
        
   
        
        
        
        if let time = data["TimeStamp"] as? Timestamp{
            self.timeStamp = time
        }
    }
    
//    func modelIntoDict() -> [String: Any]{
//        var arr = [String: Any]()
//        arr["Title"] = self.title
//        arr["Time"] = self.time
//        arr["id"] = self.id
//        arr["Type"] = self.type
//        arr["Description"] = self.descriptionText
//        arr["VideoUrl"] = self.videoUrl
//        arr["savedBy"] = self.savedByArray
//        arr["Image"] = self.image
//        arr["TimeStamp"] = self.timeStamp
//
//        return arr
//    }
    
}
