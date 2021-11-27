//
//  AppDelegate.swift
//  GrownStrong
//
//  Created by Aman on 20/07/21.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import GooglePlaces
import FirebaseMessaging




func appDelegate() -> AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {

    var window: UIWindow?
    let FIRNotificationHandlerClass : FIRNotificationHandler = FIRNotificationHandler()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        self.checkAuth()
        IQKeyboardManager.shared.enable = true
//        GMSPlacesClient.provideAPIKey("AIzaSyAg75Ekm-fJV3fmMWULmwxp-z3E5P0p3RM")
        self.regiterForFCM(application: application)
        Messaging.messaging().delegate = self
        AIReachabilityManager.sharedManager.doSetupReachability()
        return true
    }
    
    //MARK: register for remote notification
    func regiterForFCM(application : UIApplication){
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
    }
    
    //MARK: check if already login
    func checkAuth(){
        if UserManager.shared.isLoggedIn{
            let story = UIStoryboard(name: "Main", bundle:nil)
            let vc = story.instantiateViewController(withIdentifier: "SideMenuController") as! SideMenuController
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("here is fcm token",fcmToken as Any)
        UserManager.shared.token = fcmToken ?? ""
        //lauren_updates for android
        Messaging.messaging().subscribe(toTopic: "lauren_updates_ios") { (err) in
            if err == nil{
                print("subscribed")
            }else{
                print(err?.localizedDescription ?? "error")
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("here is user notification payload",userInfo)
        if let dict = userInfo as? [String: Any]{
            self.uploadNotificationOnFIR(dict: dict)
        }
    }
    
    
    func uploadNotificationOnFIR(dict: [String: Any]){
        let bodyStr = dict["body"] as? String ?? ""
        let dictionary = bodyStr.convertToDictionary()
        if dictionary != nil{
            self.FIRNotificationHandlerClass.uploadPushNotificationOnFIR(data: dictionary!) { (msg) in
                print("notification uploaded")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        print("user tap on it",response.notification.request.content.userInfo)
        if let dict = response.notification.request.content.userInfo as? [String: Any]{
            self.uploadNotificationOnFIR(dict: dict)
        }
        completionHandler()
    }
    

    func applicationDidBecomeActive(_ application: UIApplication) {
        //
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        //
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        //
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        //
        application.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        //
    }
    
}

