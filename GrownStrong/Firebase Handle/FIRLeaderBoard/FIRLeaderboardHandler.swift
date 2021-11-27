//
//  FIRLeaderboardHandler.swift
//  Lauren
//
//  Created by Rapidsofts Sahil on 15/11/21.
//

import Foundation
import FirebaseFirestore

class FIRLeaderboardHandler: NSObject {
    
    
    func fetchDailyData(completionBlock : @escaping ((_ data : [HomeTrendingModel]) -> Void)){
        let dattee = "\(Date().getCurrentDay())-\(Date().getCurrentMonth())-\(Date().getCurrentYear())"
        
        let db = Firestore.firestore().collection("leaderboard").document(dattee)
        UIApplication.topViewController()?.showLoader()
        db.getDocument { (snapshotData, err) in
            if err == nil{
                if snapshotData!.exists{
                    let data = snapshotData?.data()
                    if let useridss = data?["completed"] as? [String]{
                        var usersData : [HomeTrendingModel] = []
                        let group = DispatchGroup()
                        
                        for id in useridss{
                            
                            var singleUserData : HomeTrendingModel?
                            let userRef = Firestore.firestore().collection("Users").document(id)
                            group.enter()
                            
                            userRef.getDocument { (dataSnap, err) in
                                if err == nil{
                                    let data = dataSnap?.data()
                                    if let completedWokroutsArr = data?["workout_Challenge"] as? [[String: Any]]{
                                        var pointsss = 0
                                        for completedid in completedWokroutsArr{
                                            
                                            let points = completedid["Points"] as? Int ?? 0
                                            pointsss += points
                                        }
                                        let profileimg = data?["profileImage"] as? String ?? ""
                                        let name = data?["name"] as? String ?? ""
                                        singleUserData = HomeTrendingModel(dataSnap?.data() ?? [:], workoutID: "")
                                        singleUserData?.points = pointsss
                                        singleUserData?.title = name
                                        singleUserData?.image = profileimg
                                        usersData.append(singleUserData!)
                                        group.leave()
                                    }
                                }
                            }
                        }
                        group.notify(queue: .main) {
                            UIApplication.topViewController()?.hideLoader()
                            completionBlock(usersData)
                        }
                    }
                }else{
                    UIApplication.topViewController()?.hideLoader()
                }
            }else{
                UIApplication.topViewController()?.hideLoader()
            }
        }
        
    }
    
    
    
    func fetchAllUsersPoints(usersArray : [String],completionBlock : @escaping ((_ data : [HomeTrendingModel]) -> Void)){
        UIApplication.topViewController()?.showLoader()
        
        let group = DispatchGroup()
        var usersData : [HomeTrendingModel] = []
        
        
        
        for id in usersArray{
            group.enter()
            var singleUserData : HomeTrendingModel?
            let userRef = Firestore.firestore().collection("Users").document(id)
            userRef.getDocument { (dataSnap, err) in
                if err == nil{
                    let data = dataSnap?.data()
                    if let completedWokroutsArr = data?["workout_Challenge"] as? [[String: Any]]{
                        var pointsss = 0
                        for completedid in completedWokroutsArr{
                            var points = completedid["Points"] as? Int ?? 0
                            if points == 0{
                                points = Int(completedid["Points"] as? String ?? "0") ?? 0
                            }
                            pointsss += points
                        }
                        let profileimg = data?["profileImage"] as? String ?? ""
                        let name = data?["name"] as? String ?? ""
                        singleUserData = HomeTrendingModel(dataSnap?.data() ?? [:], workoutID: "")
                        singleUserData?.points = pointsss
                        singleUserData?.title = name
                        singleUserData?.image = profileimg
                        usersData.append(singleUserData!)
                        group.leave()
                    }else{
                        UIApplication.topViewController()?.hideLoader()
                        group.leave()
                    }
                }else{
                    UIApplication.topViewController()?.hideLoader()
                }
            }
            
        }
        
        group.notify(queue: .main) {
            UIApplication.topViewController()?.hideLoader()
            
            completionBlock(usersData)
        }
        
        
    }
    
    func fetchAllTimeData(completionBlock : @escaping ((_ data : [String]) -> Void)){
        let db = Firestore.firestore().collection("leaderboard")
        UIApplication.topViewController()?.showLoader()
        db.getDocuments { (snapShotData, error) in
            if error == nil{
                
                var userArray = [String]()
                
                for data in snapShotData!.documents{
                    let dataDict = data.data()
                    if let userids = dataDict["completed"] as? [String]{
                        
                        for id in userids{
                            if userArray.contains(id) == false{
                                print("appending ID ",id)
                                userArray.append(id)
                            }
                        }
                    }
                }
                UIApplication.topViewController()?.hideLoader()
                completionBlock(userArray)
                
            }else{
                UIApplication.topViewController()?.hideLoader()
            }
        }
    }
    
    
    func fetchMonthlyDataUserIds(completionBlock : @escaping ((_ data : [String]) -> Void)){
        let ref = Firestore.firestore().collection("leaderboard")
        let currentMonth = Date().getCurrentMonth()
        UIApplication.topViewController()?.showLoader()

        ref.whereField("month", isEqualTo: currentMonth).getDocuments { (snapShotData, error) in
            if error == nil{
                
                var userArray = [String]()
                
                for data in snapShotData!.documents{
                    let dataDict = data.data()
                    if let userids = dataDict["completed"] as? [String]{
                        
                        for id in userids{
                            if userArray.contains(id) == false{
                                userArray.append(id)
                            }
                        }
                    }
                }
                UIApplication.topViewController()?.hideLoader()
                completionBlock(userArray)
                
            }else{
                UIApplication.topViewController()?.hideLoader()
            }
        }
    }
    
    func fetchMonthlyData(usersArray : [String],completionBlock : @escaping ((_ data : [HomeTrendingModel]) -> Void)){
        
//        UIApplication.topViewController()?.showLoader()
        
        let ref = Firestore.firestore().collection("leaderboard")
        let currentMonth = Date().getCurrentMonth()
        
        ref.whereField("month", isEqualTo: currentMonth).getDocuments { (snapShotData, error) in
            if error == nil{
                var usersData : [HomeTrendingModel] = []

                let group = DispatchGroup()
                let subGroup = DispatchGroup()
                
                for data in snapShotData!.documents{
                    group.enter()
                    let dataDict = data.data()
                    if let userids = dataDict["completed"] as? [String]{
                        
                        for id in userids{
                            
                            var singleUserData : HomeTrendingModel?
                            let userRef = Firestore.firestore().collection("Users").document(id)
                            subGroup.enter()
                            
                            userRef.getDocument { (dataSnap, err) in
                                if err == nil{
                                    let data = dataSnap?.data()
                                    if let completedWokroutsArr = data?["workout_Challenge"] as? [[String: Any]]{
                                        var pointsss = 0
                                        for completedid in completedWokroutsArr{
                                            let points = completedid["Points"] as? Int ?? 0
                                            pointsss += points
                                        }
                                        let profileimg = data?["profileImage"] as? String ?? ""
                                        let name = data?["name"] as? String ?? ""
                                        singleUserData = HomeTrendingModel(dataSnap?.data() ?? [:], workoutID: "")
                                        singleUserData?.points = pointsss
                                        singleUserData?.title = name
                                        singleUserData?.image = profileimg
                                        usersData.append(singleUserData!)
                                        subGroup.leave()
                                    }
                                }
                            }
                        }
                        subGroup.notify(queue: .main) {
                            UIApplication.topViewController()?.hideLoader()
                            group.leave()
                        }
                    }
                }
                
                group.notify(queue: .main) {
                    UIApplication.topViewController()?.hideLoader()
//                    UIApplication.topViewController()?.hideLoader()

                    completionBlock(usersData)
                }
                
                
            }else{
                UIApplication.topViewController()?.hideLoader()
            }
        }
        
    }
    
    
}
