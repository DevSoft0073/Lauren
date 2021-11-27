//
//  FirebaseSetup.swift
//  GrownStrong
//
//  Created by Aman on 26/07/21.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import MBProgressHUD
import FirebaseStorage
import UIKit

class FIRController : NSObject{
    
    func loginUser(_ emailAddress : String!, password : String , completionBlock : @escaping ((_ currentUserID : String?) -> Void)){
        UIApplication.topViewController()?.showLoader()
        Auth.auth().signIn(withEmail: emailAddress, password: password) { (result, error) in
            
            if error != nil{
                UIApplication.topViewController()?.hideLoader()
                displayALertWithTitles(title: AppDefaultNames.name, message: error?.localizedDescription ?? "", ["Ok"], completion: nil)
            }else{
                //fetch userinfo
                if result!.user.isEmailVerified{
                    let db = Firestore.firestore()
                    db.collection("Users").document(result?.user.uid ?? "").getDocument { (snapshot, err) in
                        UIApplication.topViewController()?.hideLoader()
                        if err == nil{
                            if snapshot!.exists{
                                if snapshot != nil{
                                    if snapshot!.exists{
                                        let data = snapshot?.data()
                                        print("here is login user data",data as Any)
                                        UserManager.shared.userId = result?.user.uid
                                        UserManager.shared.setupUserInfoForLogin(data: data ?? [:])
                                        completionBlock(result?.user.uid)
                                    }
                                }
                            }else{
                                print("need to save info")
                                if Auth.auth().currentUser != nil{
                                    UserManager.shared.userEmailAddress = emailAddress
                                    self.saveInfoInFirestore(currentUserID: Auth.auth().currentUser?.uid ?? "") { (uid) in
                                        completionBlock(uid)
                                    }
                                }
                            }
                            
                        }else{
                            print("need to verify account")
                            displayALertWithTitles(title: AppDefaultNames.name, message: err?.localizedDescription ?? "", ["Ok"], completion: nil)
                        }
                    }
                }else{
                    UIApplication.topViewController()?.hideLoader()

                    print("need to verify account")
                    displayALertWithTitles(title: AppDefaultNames.name, message: "Please verify your account first", ["Ok"]) { (index) in
                        //
                    }
                }
            }
            
        }
        
    }
    
    
    
    private var authUser : User? {
        return Auth.auth().currentUser
    }

    public func sendVerificationMail(completionBlock : @escaping ((_ currentUserID : String?) -> Void)) {
        if self.authUser != nil {
            authUser?.reload(completion: { (err) in
                if self.authUser != nil && !self.authUser!.isEmailVerified {
                    self.authUser!.sendEmailVerification(completion: { (error) in
                        // Notify the user that the mail has sent or couldn't because of an error.
                        UIApplication.topViewController()?.hideLoader()

                        if error == nil{
                            DispatchQueue.main.async {
                                
                                displayALertWithTitles(title: AppDefaultNames.name, message: "Please check your mail for verification", ["Ok"]) { (index) in
                                    completionBlock("done")
                                }
                            }
                        }else{
                            print("error in sending email code",error?.localizedDescription ?? "")
                            displayALertWithTitles(title: AppDefaultNames.name, message: error?.localizedDescription ?? "", ["Ok"], completion: nil)
                        }
                    })
                }
                else {
                        self.saveInfoInFirestore(currentUserID: self.authUser!.uid) { (uid) in
                           completionBlock(uid)
                        }
                }
            })
        }else{
            self.createAndSaveUser { (uid) in
                completionBlock(uid)
            }
        }
    }
    
    
    func createUser(completionBlock : @escaping ((_ currentUserID : String?) -> Void)){
        UIApplication.topViewController()?.showLoader()
        sendVerificationMail { (uid) in
            completionBlock(uid)
        }
    }
    
    
    func createAndSaveUser(completionBlock : @escaping ((_ currentUserID : String?) -> Void)){
        let userInstance = Singleton.shared
        let emailAddress = userInstance.emailAddress
        let password = userInstance.password

        Auth.auth().createUser(withEmail: emailAddress, password: password) { (result, error) in
            if error != nil{
                
                UIApplication.topViewController()?.hideLoader()
                displayALertWithTitles(title: AppDefaultNames.name, message: error?.localizedDescription ?? "" , ["Ok"], completion: nil)
            }else{
                UserManager.shared.userId = result?.user.uid
                if result!.user.isEmailVerified{
                    self.saveInfoInFirestore(currentUserID: result?.user.uid ?? "") { (uid) in
                        completionBlock(uid)
                    }
                }
                else{
                    self.sendVerificationMail { (userid) in
                        completionBlock(userid)
                    }
                }
        }
            }
        }
    
    
    
func saveInfoInFirestore( currentUserID : String,completionBlock : @escaping ((_ currentUserID : String?) -> Void)){
        if Singleton.shared.isProfileImageSelected{
            let storageRef = Storage.storage().reference().child("ProfileImage\(currentUserID)")
            if let uploadData = Singleton.shared.profileImage?.jpegData(compressionQuality: 0.5){
                storageRef.putData(uploadData, metadata: nil) { (storageData, err) in
                    if err == nil{
                        storageRef.downloadURL { (url, err) in
                            if err == nil{
                                self.addUserInfoOnFireStore(profileUrl: url?.absoluteString ?? "", uid: currentUserID) { (uid) in
                                    print("here is uploaded url ",url?.absoluteString ?? "")
                                    completionBlock(uid)
                                }
                            }
                        }
                    }
                }
            }
        }else{
            self.addUserInfoOnFireStore(profileUrl: "", uid: currentUserID) { (uid) in
                completionBlock(uid)
            }
        }
    }

    func resetPassword( email : String,completionBlock : @escaping ((_ msg : String?) -> Void)){
        UIApplication.topViewController()?.showLoader()
        Auth.auth().sendPasswordReset(withEmail: email) { (err) in
            UIApplication.topViewController()?.hideLoader()
            if err == nil{
                completionBlock("reset link sent")
            }else{
                displayALertWithTitles(title: AppDefaultNames.name, message: err?.localizedDescription ?? "", ["Ok"], completion: nil)
            }
        }

        
        }

    
    
    
    
    func handleError(error: Error) {
        let errorAuthStatus = AuthErrorCode.init(rawValue: error._code)!
        switch errorAuthStatus {
        case .wrongPassword:
            print("wrongPassword")
        case .invalidEmail:
            print("invalidEmail")
        case .operationNotAllowed:
            print("operationNotAllowed")
        case .userDisabled:
            print("userDisabled")
        case .userNotFound:
            print("userNotFound")
        //             self.register(auth: Auth.auth())
            self.createAndSaveUser { (uid) in
                print("created in err,",uid ?? "")
            }
        case .tooManyRequests:
            DispatchQueue.main.async {
                displayALertWithTitles(title: AppDefaultNames.name, message: error.localizedDescription, ["Ok"], completion: nil)
            }
            print("tooManyRequests, oooops")
        default: fatalError("error not supported here")
        }
        
    }
    
    
    func addUserInfoOnFireStore(profileUrl:String,uid: String, completionBlock : @escaping ((_ currentUserID : String?) -> Void)){
        
        let db = Firestore.firestore()
        let userInstance = Singleton.shared
        let userManager = UserManager.shared
        if userInstance.name == ""{
            userInstance.name = userManager.fullName ?? ""
            userInstance.emailAddress = userManager.userEmailAddress ?? ""
            userInstance.gender = userManager.gender ?? ""
            userInstance.location = userManager.location ?? ""
            userInstance.workoutPlace = userManager.workoutPlace ?? ""
            userInstance.birthday = userManager.birthday ?? ""
            userInstance.skillLevel = userManager.skillLevel ?? ""
        }
        let doubleLat = Double(userManager.lattitude ?? "0")
        let doubleLng = Double(userManager.longtitude ?? "0")
        
        let userData = ["name":userInstance.name,"emailAddress":userInstance.emailAddress, "profileImage":profileUrl,"gender":userInstance.gender,"location":userInstance.location,"workoutPlace":userInstance.workoutPlace,"birthday":userInstance.birthday,"skillLevel":userInstance.skillLevel,"token":UserManager.shared.token ?? "","TimeStamp":Timestamp(),"current_weight":userManager.currentWeight ?? "","device_type":"iOS","goal_weight":userManager.goalWeight ?? "","start_weight":userManager.currentWeight ?? "","uid":userManager.userId ?? "","lat":doubleLat ?? 0.0,"lng":doubleLng ?? 0.0] as [String : Any]
        db.collection("Users").document(uid).setData(userData as [String : Any], merge: false) { (err) in
            UIApplication.topViewController()?.hideLoader()
            if err == nil{
//                UserManager.shared.isLoggedIn = true
                let user = UserManager.shared
                user.userId = uid
                user.fullName = userInstance.name
                user.userEmailAddress = userInstance.emailAddress
                user.profileImage = profileUrl
                user.gender = userInstance.gender
                user.location = userInstance.location
                user.workoutPlace = userInstance.workoutPlace
                user.birthday = userInstance.birthday
                user.skillLevel = userInstance.skillLevel
                
                completionBlock(uid)
            }else{
                displayALertWithTitles(title: AppDefaultNames.name, message: err?.localizedDescription ?? "", ["Ok"], completion: nil)
            }
        }
        
    }

    func updateUserInfo(isprofileImgSeletced : Bool,profileImg : UIImage,name: String,DOB:String,gender:String,location:String, completionBlock : @escaping ((_ currentUserID : String?) -> Void)){
        UIApplication.topViewController()?.showLoader()
        if isprofileImgSeletced{
            let storageRef = Storage.storage().reference().child("ProfileImage\(UserManager.shared.userId ?? "")")
            
            if let uploadData = profileImg.jpegData(compressionQuality: 0.5){
                storageRef.putData(uploadData, metadata: nil) { (storageData, err) in
                    if err == nil{
                        storageRef.downloadURL { (url, err) in
                            if err == nil{
                                let dataFields = ["name":name,"gender":gender,"birthday":DOB,"location":location,"profileImage":url?.absoluteString] as! [String:String]
                                self.updateUserInfoCommon(dataFields: dataFields) { (uid) in
                                    UserManager.shared.profileImage = url?.absoluteString
                                    UIApplication.topViewController()?.hideLoader()
                                    completionBlock("done")
                                }
                            }else{
                                UIApplication.topViewController()?.hideLoader()
                                displayALertWithTitles(title: AppDefaultNames.name, message: err?.localizedDescription ?? "", ["Ok"], completion: nil)
                            }
                        }
                    }else{
                        UIApplication.topViewController()?.hideLoader()
                        displayALertWithTitles(title: AppDefaultNames.name, message: err?.localizedDescription ?? "", ["Ok"], completion: nil)
                    }
                }
            }
        }else{
            let dataFields = ["name":name,"gender":gender,"birthday":DOB,"location":location]
            self.updateUserInfoCommon(dataFields: dataFields) { (uid) in
                UIApplication.topViewController()?.hideLoader()
                completionBlock("done")
            }
        }
    }
    
    
    func fetchUserInfo(){
        let ref = Firestore.firestore().collection("Users").document(UserManager.shared.userId!)
        ref.getDocument { (snapData, err) in
            if err == nil{
                let data = snapData?.data()
                UserManager.shared.setupUserInfoForLogin(data: data!)
                
            }
        }
    }
    
    
    
    func updateCurrentWeight(weight: String, completionBlock : @escaping ((_ message : String?) -> Void)){
        //current_weight
        
        self.checkAndUpdateLastMonthWeight { (msg) in
            UIApplication.topViewController()?.showLoader()
            let db = Firestore.firestore()
            db.collection("Users").document(UserManager.shared.userId!).updateData(["current_weight":weight]) { (err) in
                if err == nil{
                    UIApplication.topViewController()?.hideLoader()
                    completionBlock("done")
                }else{
                    UIApplication.topViewController()?.hideLoader()
                }
            }
        }
    }
    
    
    func checkAndUpdateLastMonthWeight( completionBlock : @escaping ((_ message : String?) -> Void)){
        //lastMonthWeight
        let ref = Firestore.firestore().collection("Users").document(UserManager.shared.userId!)
        ref.getDocument { (snapData, err) in
            if err == nil{
                let data = snapData!.data()
                if let lastMonthWeightArr = data?["lastMonthWeight"] as? [String: Any]{
                    let previousMonthDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
                    let previousMonth = Date().getCurrentMonthForSpecificDate(date: previousMonthDate!)
                    
                    let savedMonth = lastMonthWeightArr["month"] as? Int ?? 0
                    if savedMonth != previousMonth{
                        print("dates are not same")
                        self.updateLastMonthWeight { (msg) in
                            completionBlock(msg)
                        }
                    }else{
                        completionBlock("No need to update")
                        print("here is saved month and previous month",savedMonth,previousMonth)
                    }
                }else{
                    print("need to update last month weight")
                    
                    self.updateLastMonthWeight { (msg) in
                        completionBlock(msg)
                    }
                }
            }
        }
    }
    
    func updateLastMonthWeight( completionBlock : @escaping ((_ message : String?) -> Void)){
        let ref = Firestore.firestore().collection("Users").document(UserManager.shared.userId!)
        let previousMonthDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        let previousMonth = Date().getCurrentMonthForSpecificDate(date: previousMonthDate!)
        let data = ["month" : previousMonth,"weight":UserManager.shared.currentWeight!] as [String : Any]
        ref.updateData(["lastMonthWeight":data]) { (err) in
            if err == nil{
                completionBlock("saved last month weight")
            }
        }
        
    }
    
    
    
    func updateUserInfoCommon(dataFields:[String:String], completionBlock : @escaping ((_ currentUserID : String?) -> Void)){
        let db = Firestore.firestore()
        db.collection("Users").document(UserManager.shared.userId ?? "").updateData(dataFields) { (err) in
            if err != nil{
                UIApplication.topViewController()?.hideLoader()
                
                displayALertWithTitles(title: AppDefaultNames.name, message: err?.localizedDescription ?? "", ["Ok"], completion: nil)
            }else{
                completionBlock("done")
            }
        }
    }
    
    func updateToken(token : String,completionBlock : @escaping ((_ message : String?) -> Void)){
        let db = Firestore.firestore()
        db.collection("Users").document(UserManager.shared.userId ?? "").updateData(["token" : token]) { (err) in
            if err != nil{
                
            }else{
                completionBlock("done")
            }
        }
    }
    
    func removeFCMToken(completionBlock : @escaping ((_ message : String?) -> Void)){
        let db = Firestore.firestore()
        db.collection("Users").document(UserManager.shared.userId ?? "").updateData(["token" : ""]) { (err) in
            if err != nil{
                print("error in remove token",err?.localizedDescription ?? "err")
            }else{
                completionBlock("token removed")
            }
        }
    }
    
    
    func logout(){
        DispatchQueue.main.async {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
            self.removeFCMToken { (msg) in
                print("token removed")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                UserManager.shared.clear()
            }
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "LaunchViewController") as? LaunchViewController
            let nav = UINavigationController(rootViewController: vc!)
            nav.navigationBar.isHidden = true
            appDelegate().window?.rootViewController = nav
        }
        
        
        
    }
    
}

