//
//  WorkoutMovementModel.swift
//  GrownStrong
//
//  Created by Aman on 02/09/21.
//

import Foundation

class WorkoutMovementModel : NSObject{
//    var workoutID = ""
    var roundName = ""
    var time = ""
    var movementIDs = [String]()
    var movements : [Submovements] = []
    
    init(_ data : [String : Any],subData : [Submovements]) {
        self.roundName = "Round \(data["Round"] as? String ?? "")"
        self.time = data["Title"] as? String ?? ""
        self.movements = subData
        self.movementIDs = data["movementIDs"] as? [String] ?? []
    }
    
}


class Submovements:NSObject{
    
    var title = ""
    var time = ""
    var videoURL = ""
    var image = ""
    
    init(_ data : [String: Any]){
        self.title = data["Title"] as? String ?? ""
        self.time = data["Time"] as? String ?? ""
        self.videoURL = data["VideoURL"] as? String ?? ""
        self.image = data["Image"] as? String ?? ""
    }
}


