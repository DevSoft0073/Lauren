//
//  FIRStatsHandler.swift
//  Lauren
//
//  Created by Rapidsofts Sahil on 16/11/21.
//

import UIKit
import FirebaseFirestore

class FIRStatsHandler: NSObject {

    func fetchStatsData(completionBlock : @escaping ((_ data : [StatsModel],_ lastMonthWeight : String) -> Void)){
        //workout_Challenge   //  Type == workout
        var monthData : [StatsModel] = []
        UIApplication.topViewController()?.showLoader()
        let ref = Firestore.firestore().collection("Users").document(UserManager.shared.userId!)
        ref.getDocument { (snapData, err) in
            if err == nil{
                let data = snapData!.data()
                var lastWeight = ""
                if let lastData = data?["lastMonthWeight"] as? [String: Any]{
                    lastWeight = lastData["weight"] as? String ?? "0"
                }
                if let compltedWorkouts = data?["workout_Challenge"] as? [[String: Any]]{
                   
                    for dict in compltedWorkouts{
                        let type = dict["Type"] as? String ?? ""
                        if type == "workout"{
                            monthData.append(StatsModel(data: dict))
                        }
                    }
                    UIApplication.topViewController()?.hideLoader()
                    completionBlock(monthData,lastWeight)
                }else{
                    UIApplication.topViewController()?.hideLoader()
                    completionBlock(monthData,lastWeight)
                }
            }else{
                UIApplication.topViewController()?.hideLoader()
            }
        }
    }
    
    
    func fetchCaleroiesNData(data :[StatsModel] ,completionBlock : @escaping ((_ calories : String,_ streaks : String) -> Void)){
        UIApplication.topViewController()?.showLoader()
        
        var caloriesCount = 0
        let group = DispatchGroup()
        for dataDict in data{
            group.enter()
            let ref = Firestore.firestore().collection("Workout").document(dataDict.workoutID)
            ref.getDocument { (snapData, err) in
                if err == nil{
                    let data = snapData?.data()
                    let calory = data?["calories"] as? String ?? ""
                    caloriesCount += Int(calory) ?? 0
                    group.leave()
                }else{
                    UIApplication.topViewController()?.hideLoader()
                }
            }
        }
        
        group.notify(queue: .main) {
            UIApplication.topViewController()?.hideLoader()
            completionBlock("\(caloriesCount)","")
        }
        
        
    }
  
    
    
    
}


class StatsModel : NSObject{
    var month = 0
    var points = 0
    var type = ""
    var workoutID = ""
    var day = 0
    var year = 0
    var calories = ""
    
    init(data : [String: Any]){
        self.month = data["month"] as? Int ?? 1
        self.points = data["Points"] as? Int ?? 0
        self.workoutID = data["idds"] as? String ?? ""
        self.type = data["Type"] as? String ?? ""
        self.day = data["day"] as? Int ?? 0
        self.year = data["year"] as? Int ?? 0
        self.calories = data["calories"] as? String ?? ""

    }
    
}

