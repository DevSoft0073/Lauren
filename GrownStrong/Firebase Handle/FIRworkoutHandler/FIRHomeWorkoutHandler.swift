//
//  FIRHomeWorkoutHandler.swift
//  GrownStrong
//
//  Created by Aman on 31/08/21.
//

import Foundation
import FirebaseFirestore
import MBProgressHUD


enum WorkoutTypes{
    static let TrendingWorkout = "Trending"
    static let ExploreWokrout = "Explore"
    static let DailyWorkout = "Daily"
    static let EducationWorkout = "Education"
}




class FIRHomeHandler : NSObject{
    //    var homeWorkoutRef = Firestore.firestore().collection("Home")
    var workoutRef = Firestore.firestore().collection("Workout")
    var lastDocumentSnapshot: DocumentSnapshot!
    var savedlastDocumentSnapshot: DocumentSnapshot!

    
    var homeTrendingModel : [HomeTrendingModel] = [HomeTrendingModel]()
    var homeExploreModel : [HomeExploreModel] = [HomeExploreModel]()
    
    var workoutModel : [HomeTrendingModel] = [HomeTrendingModel]()
    
    var mainCategories : [MainCategoriesModel] = [MainCategoriesModel]()
    
    func fetchMainCategories(completionBlock : @escaping ((_ data : [MainCategoriesModel]) -> Void)){
        let ref = Firestore.firestore().collection("WorkoutCategories")
        
        ref.getDocuments { (snapshot, err) in
            if err == nil{
                if !snapshot!.documents.isEmpty{
                    self.mainCategories.removeAll()
                    for data in snapshot!.documents{
                        self.mainCategories.append(MainCategoriesModel(data.data(), id: data.documentID))
                    }
                    completionBlock(self.mainCategories)
                }
            }
        }
    }
    
    
    func fetchHomeTrendingData( trendinGID : String,completionBlock : @escaping ((_ data : [HomeTrendingModel]) -> Void)){
        
        var query: Query!
        
        if self.homeTrendingModel.isEmpty{
            query =  workoutRef.whereField("Type", in: [trendinGID]).order(by: "TimeStamp").limit(to: 10)
        }else{
            query =  workoutRef.whereField("Type", in: [trendinGID]).order(by: "TimeStamp").start(afterDocument: self.lastDocumentSnapshot).limit(to: 10)
        }
        query.getDocuments { (snapshot, err) in
            if err == nil{
                if !snapshot!.documents.isEmpty{
                    self.homeTrendingModel.removeAll()
                    self.lastDocumentSnapshot = snapshot?.documents.last
                    
                    for data in snapshot!.documents{
                        let dict = data.data()
                        self.homeTrendingModel.append(HomeTrendingModel(dict,workoutID: data.documentID))
                    }
                    completionBlock(self.homeTrendingModel)
                }else{
                }
            }else{
                DispatchQueue.main.async {
                    displayALertWithTitles(title: AppDefaultNames.name, message: err?.localizedDescription ?? "", ["Ok"], completion: nil)
                }
            }
        }
        
    }
    
    
    func fetchHomeExploreData(exploreID : String ,completionBlock : @escaping ((_ exploreData : [HomeExploreModel]) -> Void)){
        UIApplication.topViewController()?.showLoader()
        
        //        var query: Query!
        //
        //
        //        if self.homeTrendingModel.isEmpty{
        //            query =  workoutRef.order(by: "Timestamp").limit(toLast: 4)
        //        }else{
        //            query = workoutRef.order(by: "Timestamp").start(afterDocument: self.lastDocumentSnapshot).limit(to: 4)
        //        }
        workoutRef.whereField("Type", in: [exploreID]).getDocuments { (snapshot, err) in
            if err == nil{
                if !snapshot!.documents.isEmpty{
                    self.homeExploreModel.removeAll()
                    self.lastDocumentSnapshot = snapshot?.documents.last
                    
                    for data in snapshot!.documents{
                        let dict = data.data()
                        self.homeExploreModel.append(HomeExploreModel(dict))
                    }
                    UIApplication.topViewController()?.hideLoader()
                    completionBlock(self.homeExploreModel)
                }
            }else{
                DispatchQueue.main.async {
                    UIApplication.topViewController()?.hideLoader()
                    displayALertWithTitles(title: AppDefaultNames.name, message: err?.localizedDescription ?? "", ["Ok"], completion: nil)
                }
            }
        }
        
    }
    
    
    
    
    func fetchWorkoutData( type : [String],completionBlock : @escaping ((_ data : [HomeTrendingModel]) -> Void)){
        UIApplication.topViewController()?.showLoader()
        workoutRef.whereField("Type", in: type).limit(to: 10).getDocuments{ (snapshot, err) in
            if err == nil{
                if !snapshot!.documents.isEmpty{
                    self.workoutModel.removeAll()
                    for data in snapshot!.documents{
                        let dict = data.data()
                        self.workoutModel.append(HomeTrendingModel(dict,workoutID: data.documentID))
                    }
                    UIApplication.topViewController()?.hideLoader()
                    completionBlock(self.workoutModel)
                }
            }else{
                DispatchQueue.main.async {
                    UIApplication.topViewController()?.hideLoader()
                    displayALertWithTitles(title: AppDefaultNames.name, message: err?.localizedDescription ?? "", ["Ok"], completion: nil)
                }
            }
        }
        
    }
    
    
    var lastWorkoutDocumentSnapshotForEducation: DocumentSnapshot!
    var lastWorkoutDocumentSnapshotForDaily: DocumentSnapshot!

    
    func fetchWorkoutPaginateData( type : [String],completionBlock : @escaping ((_ data : [HomeTrendingModel]) -> Void)){
        var query: Query!
        
        if self.workoutModel.isEmpty{
            query =  workoutRef.whereField("Type", in: type).order(by: "Timestamp").limit(to: 10)
        }else{
//            if type.contains(WorkoutTypes.DailyWorkout){
                query =  workoutRef.whereField("Type", in: type).order(by: "Timestamp").start(afterDocument: self.lastWorkoutDocumentSnapshotForDaily).limit(to: 10)

//            }else{
//                query =  workoutRef.whereField("Type", in: type).order(by: "Timestamp").start(afterDocument: self.lastWorkoutDocumentSnapshotForEducation).limit(to: 10)

//            }
        }
        
        query.getDocuments { (snapshot, err) in
            if err == nil{
                if !snapshot!.documents.isEmpty{
                    self.workoutModel.removeAll()
//                    if type.contains(WorkoutTypes.DailyWorkout){
                        self.lastWorkoutDocumentSnapshotForDaily = snapshot?.documents.last
//                    }else{
//                        self.lastWorkoutDocumentSnapshotForEducation = snapshot?.documents.last
//                    }
                    
                    for data in snapshot!.documents{
                        let dict = data.data()
                        self.workoutModel.append(HomeTrendingModel(dict,workoutID: data.documentID))
                    }
                    completionBlock(self.workoutModel)
                }else{
                }
            }else{
                DispatchQueue.main.async {
                    displayALertWithTitles(title: AppDefaultNames.name, message: err?.localizedDescription ?? "", ["Ok"], completion: nil)
                }
            }
        }
        
    }
    
    
    func saveWorkoutInDatabse(isWorkoutfromHome :Bool ,workoutModel : HomeTrendingModel,completionBlock : @escaping ((_ msg : String) -> Void)){
        let ref = Firestore.firestore().collection("Users").document(UserManager.shared.userId ?? "")
        
        if workoutModel.savedByArray.contains(UserManager.shared.userId!){
            if UserManager.shared.savedWorkoutsIDs != nil{
                UserManager.shared.savedWorkoutsIDs = UserManager.shared.savedWorkoutsIDs?.filter { $0 != workoutModel.id}
            }
            ref.getDocument { (snapshot, err) in
                if err == nil{
                    let data = snapshot?.data()
                    if let savedWorkouts = data?["SavedWorkout"] as? [String]{
                       var arr = savedWorkouts
                        arr = arr.filter { $0 != workoutModel.id}
                        ref.updateData(["SavedWorkout":arr]) { (err) in
                            if err == nil{
                                
                                var arr = workoutModel.savedByArray
                                arr = arr.filter { $0 != UserManager.shared.userId! }
                                self.workoutRef.document(workoutModel.id).updateData(["savedBy":arr]) { (err) in
                                    if err == nil{
                                       
                                        completionBlock("deleted")
                                    }
                                }
//                                completionBlock("workout unsaved")
                            }
                        }
                    }
                }
            }

        }else{
            if UserManager.shared.savedWorkoutsIDs != nil{
                UserManager.shared.savedWorkoutsIDs?.append(workoutModel.id)
            }

            ref.getDocument { (snapshot, err) in
                if err == nil{
                    let data = snapshot?.data()
                    var arrayOfIDs = [String]()
                    
                    if let savedWorkouts = data?["SavedWorkout"] as? [String]{
                        arrayOfIDs = savedWorkouts
                    }
                    arrayOfIDs.append(workoutModel.id)

                    ref.updateData(["SavedWorkout":arrayOfIDs]) { (err) in
                        if err == nil{
                            workoutModel.savedByArray.append(UserManager.shared.userId!)
                            self.workoutRef.document(workoutModel.id).updateData(["savedBy":workoutModel.savedByArray]) { (err) in
                                if err == nil{
                                    completionBlock("saved")
                                }
                            }
                        }
                    }
                }
            }

        }
        
    }
    
    
    var workoutSavedModel : [HomeTrendingModel] = [HomeTrendingModel]()

    func fetchSavedWorkouts(completionBlock : @escaping ((_ data : [HomeTrendingModel]) -> Void)){
//
//        var query: Query!
//
//        if self.workoutSavedModel.isEmpty{
//            query =  ref.order(by: "TimeStamp").limit(to: 5)
//        }else{
//            query =  ref.order(by: "TimeStamp").start(afterDocument: self.savedlastDocumentSnapshot).limit(to: 5)
//        }
//
//        query.getDocuments { (snapshot, err) in
//            if err == nil{
//                if snapshot!.documents.isEmpty{
////                    completionBlock(self.workoutSavedModel)
//                }else{
//                    self.savedlastDocumentSnapshot = snapshot?.documents.last
//
//                    self.workoutSavedModel.removeAll()
//                    for data in snapshot!.documents{
//                        self.workoutSavedModel.append(HomeTrendingModel(data.data(),workoutID: data.documentID))
//                    }
//                    completionBlock(self.workoutSavedModel)
//                }
//
//            }
//        }
        let ids = UserManager.shared.savedWorkoutsIDs
        let myGroup = DispatchGroup()
        if ids?.count ?? 0 > 0{
            self.workoutSavedModel.removeAll()
            for id in ids!{
                myGroup.enter()
                Firestore.firestore().collection("Workout").document(id).getDocument { (snapshot, err) in
                    if err == nil{
                        self.workoutSavedModel.append(HomeTrendingModel(snapshot?.data() ?? [:], workoutID: id))
                        myGroup.leave()
                    }
                }
            }
            myGroup.notify(queue: .main) {
                completionBlock(self.workoutSavedModel)
            }
        }
        
        
        
    }
    
    
    func fetchWorkoutIDs(completionBlock : @escaping ((_ message : String) -> Void)){
        let ref = Firestore.firestore().collection("Users").document(UserManager.shared.userId!)
        ref.getDocument { (snapshot, err) in
            if err == nil{
                UserManager.shared.setupUserInfoForLogin(data: (snapshot?.data())!)
                completionBlock("fetched")
            }
        }
    }
    
    
    
    func fetchWorkoutMovements(workoutID : String , completionBlock : @escaping ((_ data : [WorkoutMovementModel]) -> Void)){
        
        if workoutID == ""{
            return
        }
        
        let ref = Firestore.firestore().collection("WorkoutMovements").document(workoutID).collection("section")
        ref.getDocuments { (snapshots, err) in
            if err == nil{
                if !snapshots!.documents.isEmpty{
                    var model : [WorkoutMovementModel] = [WorkoutMovementModel]()
                    let myGroup = DispatchGroup()
                    let subGroup = DispatchGroup()
                    for docs in snapshots!.documents{
                        myGroup.enter()
                        let sectionData = docs.data()
                        print( "hereis section data",sectionData)
                        let ids = sectionData["movementIDs"] as? [String] ?? []
                        var testModel :[Submovements] = [Submovements]()
                        
                        for str in ids{
                            subGroup.enter()
                            let libraryRef = Firestore.firestore().collection("Library").document(str)
                            libraryRef.getDocument { (dataSnapshots, error) in
                                if error == nil{
                                    testModel.append(Submovements(dataSnapshots?.data() ?? [:]))
                                    subGroup.leave()
                                }
                            }
                        }
                        subGroup.notify(queue: .main) {
                            model.append(WorkoutMovementModel(docs.data(), subData: testModel))
                            myGroup.leave()
                        }
                        
                        
//                        ref.document(docs.documentID).collection("Data").getDocuments { (dataSnapshots, error) in
//                            if error == nil{
//                                var testModel :[Submovements] = [Submovements]()
//                                for data in dataSnapshots!.documents{
//                                    testModel.append(Submovements(data.data()))
//                                }
//                                model.append(WorkoutMovementModel(docs.data(), subData: testModel))
//                                myGroup.leave()
//                            }
//                        }
                    }
                    myGroup.notify(queue: .main) {
                        completionBlock(model)
                    }
                    
                }else{
                    UIApplication.topViewController()?.hideLoader()

                }
            }else{
                UIApplication.topViewController()?.hideLoader()
            }
        }
        
    }
    
    
    //LAUREN APP:
    
    
    func fetchHomeWorkouts(completionBlock : @escaping ((_ data : [HomeTrendingModel]) -> Void)){
        
        UIApplication.topViewController()?.showLoader()
        let ref = Firestore.firestore().collection("Workout")
        ref.order(by: "TimeStamp", descending: true).getDocuments { (snapshot, err) in
            if err == nil{
                if snapshot!.documents.isEmpty{
                    UIApplication.topViewController()?.hideLoader()
                }else{
                    var workoutData : [HomeTrendingModel] = [HomeTrendingModel]()
                    
                    for data in snapshot!.documents{
                        workoutData.append(HomeTrendingModel(data.data(), workoutID: data.documentID))
                    }
//                    UIApplication.topViewController()?.hideLoader()
                    completionBlock(workoutData)
                }
                
            }else{
                UIApplication.topViewController()?.hideLoader()
            }
        }
        
    }
    
    
    func fetchHomeCHallenges(completionBlock : @escaping ((_ data : [HomeTrendingModel]) -> Void)){
        
        UIApplication.topViewController()?.showLoader()
        let ref = Firestore.firestore().collection("Challenges")
        ref.getDocuments { (snapshot, err) in
            if err == nil{
                if snapshot!.documents.isEmpty{
                    UIApplication.topViewController()?.hideLoader()
                }else{
                    var workoutData : [HomeTrendingModel] = [HomeTrendingModel]()
                    
                    for data in snapshot!.documents{
                        workoutData.append(HomeTrendingModel(data.data(), workoutID: data.documentID))
                    }
                    completionBlock(workoutData)
                }
            }else{
                UIApplication.topViewController()?.hideLoader()
            }
        }
        
    }
    
    
    //MARK: fetch challenge details
    func fetchChallnegsCategoris(completionBlock : @escaping ((_ data : [ChallengeCategoriesModel]) -> Void)){
        
        UIApplication.topViewController()?.showLoader()
        let ref = Firestore.firestore().collection("ChallengesCateogories")
        ref.getDocuments { (snapshot, err) in
            if err == nil{
                if snapshot!.documents.isEmpty{
                    UIApplication.topViewController()?.hideLoader()
                }else{
                    var challenges : [ChallengeCategoriesModel] = [ChallengeCategoriesModel]()
                    
                    for data in snapshot!.documents{
                        challenges.append(ChallengeCategoriesModel(data.data(), data.documentID))
                    }
                    completionBlock(challenges)
                }
                
            }else{
                UIApplication.topViewController()?.hideLoader()
            }
        }
        
    }
    
    func fetchWorkoutsCategories(completionBlock : @escaping ((_ data : [ChallengeCategoriesModel]) -> Void)){
        
        UIApplication.topViewController()?.showLoader()
        let ref = Firestore.firestore().collection("WorkoutCategories")
        ref.getDocuments { (snapshot, err) in
            if err == nil{
                if snapshot!.documents.isEmpty{
                    UIApplication.topViewController()?.hideLoader()
                }else{
                    var challenges : [ChallengeCategoriesModel] = [ChallengeCategoriesModel]()
                    
                    for data in snapshot!.documents{
                        challenges.append(ChallengeCategoriesModel(data.data(), data.documentID))
                    }
                    completionBlock(challenges)
                }
                
            }else{
                UIApplication.topViewController()?.hideLoader()
            }
        }
        
    }
    
    func saveWorkoutsOrChallenge(isChallenge:Bool,workoutModel:HomeTrendingModel ,completionBlock : @escaping ((_ message : String) -> Void)){
        let ref = Firestore.firestore().collection("Users").document(UserManager.shared.userId ?? "")
        var ourArray = [String]()
        var keyInFIR = ""
        if isChallenge{
            ourArray = UserManager.shared.savedChallengeIDs ?? []
            keyInFIR = "saved_challenges"
        }else{
            ourArray = UserManager.shared.savedWorkoutsIDs ?? []
            keyInFIR = "saved_workouts"
        }
        
        if ourArray.contains(workoutModel.id){
            ourArray = ourArray.filter { $0 != workoutModel.id}
            if isChallenge{
                UserManager.shared.savedChallengeIDs = ourArray
            }else{
               UserManager.shared.savedWorkoutsIDs = ourArray
            }
            ref.updateData([keyInFIR:ourArray]) { (err) in
                if err == nil{
                    completionBlock("removed")
                }
            }

        }else{
            ourArray.append(workoutModel.id)
            if isChallenge{
                UserManager.shared.savedChallengeIDs = ourArray
            }else{
               UserManager.shared.savedWorkoutsIDs = ourArray
            }
            ref.updateData([keyInFIR:ourArray]) { (err) in
                if err == nil{
                    completionBlock("added")
                }
            }
        }
        
    }
    

    
    func fetchWorkoutDetailMovements(WorkoutID : String,completionBlock : @escaping ((_ data : [WorkoutDetailMovementsModel]) -> Void)){
        
        let ref = Firestore.firestore().collection("WorkoutMovements").document(WorkoutID)
        
        ref.getDocument { (snapShot, err) in
            if err == nil{
                if snapShot!.exists{
                    if  let arr = snapShot!.data()?["movements"] as? [String]{
                        print(arr)
                        let myGroup = DispatchGroup()
                        var movementsData : [WorkoutDetailMovementsModel] = [WorkoutDetailMovementsModel]()
                        for movement in arr{
                            myGroup.enter()
                            let movementRef = Firestore.firestore().collection("movements")
                            movementRef.document(movement).getDocument { (snapData, error) in
                                if error == nil{
                                    if snapData!.exists{
                                        movementsData.append(WorkoutDetailMovementsModel(snapData!.data()!, snapData!.documentID))
                                        myGroup.leave()
                                    }
                                }
                            }
                        }
                        
                        myGroup.notify(queue: .main) {
                            completionBlock(movementsData)
                        }
                    }
                }
            }
        }
        
    }
    
    func fetchChallenegWeeks(WorkoutID : String,completionBlock : @escaping ((_ data : [WorkoutDetailMovementsModel]) -> Void)){
        
        let ref = Firestore.firestore().collection("ChallengeWeek").document(WorkoutID)
        ref.getDocument { (snapshot, err) in
            if err == nil{
                let dta = snapshot!.data()
                if let weeksArry = dta?["weeks"] as? [[String: Any]]{
                    var movementsArr : [WorkoutDetailMovementsModel] = [WorkoutDetailMovementsModel]()
                    for arr in weeksArry{
                        let movementModel = WorkoutDetailMovementsModel(arr, "")
                        movementsArr.append(movementModel)
                    }
                    print(movementsArr.count)
                    completionBlock(movementsArr)
                }
            }
        }
    }
    
    
    func fetchSavedWorkoutsForProfile(completionBlock : @escaping ((_ data : [HomeTrendingModel]) -> Void)){
        
        let ref = Firestore.firestore().collection("Workout")
        UIApplication.topViewController()?.showLoader()
        var workoutsData : [HomeTrendingModel] = [HomeTrendingModel]()

        let savedIds = UserManager.shared.savedWorkoutsIDs
        let group = DispatchGroup()
        for workoutID in savedIds ?? []{
            group.enter()
            
            ref.document(workoutID).getDocument { (snapData, err) in
                if err == nil{
                    let data = snapData?.data()
                    workoutsData.append(HomeTrendingModel(data ?? [:], workoutID: snapData?.documentID ?? ""))
                    group.leave()
                }else{
                    UIApplication.topViewController()?.hideLoader()
                }
            }
        }
        
        group.notify(queue: .main) {
            UIApplication.topViewController()?.hideLoader()
            completionBlock(workoutsData)
        }
    }
    
    func fetchCompletedWorkouts(workoutStatsData :[StatsModel] , completionBlock : @escaping ((_ data : [HomeTrendingModel]) -> Void)){
        
        let ref = Firestore.firestore().collection("Workout")
        UIApplication.topViewController()?.showLoader()
        var workoutsData : [HomeTrendingModel] = [HomeTrendingModel]()
        
        let group = DispatchGroup()
        for workoutID in workoutStatsData{
            group.enter()
            
            ref.document(workoutID.workoutID).getDocument { (snapData, err) in
                if err == nil{
                    let data = snapData?.data()
                    workoutsData.append(HomeTrendingModel(data ?? [:], workoutID: snapData?.documentID ?? ""))
                    group.leave()
                }else{
                    UIApplication.topViewController()?.hideLoader()
                }
            }
        }
        
        group.notify(queue: .main) {
            UIApplication.topViewController()?.hideLoader()
            completionBlock(workoutsData)
        }
    }
    
    
    
    func saveCompletedWokrout(workout : HomeTrendingModel,isChallenge : Bool,completionBlock : @escaping ((_ message : String) -> Void)){
        var type = ""
        if isChallenge{
            type = "challenge"
        }else{
            type = "workout"
        }
        UIApplication.topViewController()?.showLoader()
        let ref = Firestore.firestore().collection("Users").document(UserManager.shared.userId ?? "")
            ref.getDocument { (snapshot, err) in
            if err == nil{
                let data = snapshot!.data()
                var completedArr = [[String: Any]]()
                if let savedWorkoutsArr = data?["workout_Challenge"] as? [[String: Any]]{
                    completedArr = savedWorkoutsArr
                }
                    
                let newArr = ["calories":workout.calories,"Points":workout.points,"Type":type,"idds":workout.id,"day":Date().getCurrentDay(),"month":Date().getCurrentMonth(),"year": Date().getCurrentYear()] as [String : Any]
                    completedArr.append(newArr)
                    let newRef = Firestore.firestore().collection("Users").document(UserManager.shared.userId!)
                    newRef.updateData(["workout_Challenge":completedArr]) { (err) in
                        if err == nil{
                            //UIApplication.topViewController()?.hideLoader()
                            UserManager.shared.completedWorkouts = completedArr
                            let dattee = "\(Date().getCurrentDay())-\(Date().getCurrentMonth())-\(Date().getCurrentYear())"
                            print(dattee)
                            let leaderBoardRef = Firestore.firestore().collection("leaderboard").document(dattee)
                            leaderBoardRef.getDocument { (snapshotData, err) in
                                if err == nil{
                                        var idsArr = [String]()
                                        if var completedIds = snapshotData?.data()?["completed"] as? [String]{
                                            if completedIds.contains(UserManager.shared.userId!){
                                                
                                            }else{
                                                completedIds.append(UserManager.shared.userId!)
                                            }
                                            idsArr = completedIds
                                        }else{
                                            idsArr.append(UserManager.shared.userId!)
                                        }
                                        let arr = ["completed":idsArr,"day":Date().getCurrentDay(),"month":Date().getCurrentMonth(),"year": Date().getCurrentYear()] as [String : Any]
                                        leaderBoardRef.setData(arr) { (err) in
                                            if err == nil{
                                                UIApplication.topViewController()?.hideLoader()
                                               completionBlock("mark as completed")
                                            }else{
                                                UIApplication.topViewController()?.hideLoader()

                                            }
                                        }
                                        
                                   
                                    
                                    
                                }else{
                                    UIApplication.topViewController()?.hideLoader()
                                }
                            }
//                            completionBlock("mark as completed")
                        }else{
                            UIApplication.topViewController()?.hideLoader()

                        }
                    }
                
            }else{
                UIApplication.topViewController()?.hideLoader()

            }
        }
    }
    
    
    func saveWorkoutForUser(workout : HomeTrendingModel,isChallenge : Bool,completionBlock : @escaping ((_ message : String) -> Void)){
        
    }
    
    
}
