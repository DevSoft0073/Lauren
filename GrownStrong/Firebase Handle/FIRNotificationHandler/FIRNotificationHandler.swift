//
//  FIRNotificationHandler.swift
//  GrownStrong
//
//  Created by Aman on 03/09/21.
//

import Foundation
import FirebaseFirestore
import MBProgressHUD


struct NotificationTypes{
    static let workoutNotification = "workout"
    static let challengeNotification = "challenge"
    static let leaderBoardNotification = "leaderboard"
    
}



class FIRNotificationHandler : NSObject{
    
    
    func uploadCompletedWONotification(isFromChallenge :Bool ,workout : HomeTrendingModel,completionBlock : @escaping ((_ data : String) -> Void)){
        var type = ""
        
        if isFromChallenge{
            type = "challenge"
        }else{
            type = "workout"
        }
        let ref = Firestore.firestore().collection("Notifications").document(UserManager.shared.userId!).collection("Data")
        UIApplication.topViewController()?.showLoader()
        let str = "Great job! You’ve earned \(workout.points) points from complete \(workout.title)."
        
        let dataDict = ["title": str,"timestamp":Timestamp(),"type":type,"id":workout.id] as [String : Any]
        
        ref.addDocument(data: dataDict) { (err) in
            UIApplication.topViewController()?.hideLoader()
            if err == nil{
               completionBlock("Done")
            }
        }
    }
    
    
    func uploadPushNotificationOnFIR(data : [String: Any],completionBlock : @escaping ((_ data : String) -> Void)){
        
        if UserManager.shared.userId == "" || UserManager.shared.userId == nil{
            return
        }
        let ref = Firestore.firestore().collection("Notifications").document(UserManager.shared.userId!).collection("Data")
        let str = data["message"] as? String ?? ""
        let type = data["type"] as? String ?? ""
        let id = data["id"] as? String ?? ""
        let status = data["status"] as? Int ?? 0
        let dataDict = ["title": str,"timestamp":Timestamp(),"type":type,"id":id,"status":status] as [String : Any]
        
        ref.addDocument(data: dataDict) { (err) in
            if err == nil{
               completionBlock("Done")
            }
        }
    }
    
    
    
    func fetchNotificationsData(completionBlock : @escaping ((_ data : [NotificationModel]) -> Void)){
        UIApplication.topViewController()?.showLoader()
        let ref = Firestore.firestore().collection("Notifications").document(UserManager.shared.userId!).collection("Data")
        ref.order(by: "timestamp", descending: true).limit(to: 10).getDocuments { (snapData, err) in
            if err == nil{
                var notifyData : [NotificationModel] = [NotificationModel]()
                for data in snapData!.documents{
                    notifyData.append(NotificationModel(data.data()))
                }
                UIApplication.topViewController()?.hideLoader()
                completionBlock(notifyData)
            }else{
                UIApplication.topViewController()?.hideLoader()
            }
        }
        
    }
    
    
    func fetchWokroutData(workoutID : String ,isChallenege: Bool, completionBlock : @escaping ((_ data : HomeTrendingModel) -> Void)){
        UIApplication.topViewController()?.showLoader()
        var nodeStr = ""
        if isChallenege{
            nodeStr = "Challenges"
        }else{
            nodeStr = "Workout"
        }
        let ref = Firestore.firestore().collection(nodeStr).document(workoutID)
        ref.getDocument { (snapdata, err) in
            if err == nil{
                var dataDict : HomeTrendingModel?
                dataDict = HomeTrendingModel(snapdata!.data()!, workoutID: snapdata!.documentID)
                UIApplication.topViewController()?.hideLoader()
                completionBlock(dataDict!)
            }else{
                UIApplication.topViewController()?.hideLoader()
            }
        }
        
    }
    
    
    
    
}
