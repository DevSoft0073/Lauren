//
//  UserManager.swift
//  GrownStrong
//
//  Created by Aman on 26/07/21.
//

import Foundation
import UIKit

class UserManager: NSObject {

    static var shared: UserManager {
        return UserManager()
    }
    
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: "token")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "token")
            UserDefaults.standard.synchronize()
        }
    }
    
    var fullName: String? {
          get {
              return UserDefaults.standard.string(forKey: "fullName")
          }
          set {
              UserDefaults.standard.set(newValue, forKey: "fullName")
              UserDefaults.standard.synchronize()
          }
      }
    
    
  
    
    
    var savedWorkoutsIDs: [String]? {
          get {
            return UserDefaults.standard.value(forKey: "savedWorkouts") as? [String]
          }
          set {
              UserDefaults.standard.set(newValue, forKey: "savedWorkouts")
              UserDefaults.standard.synchronize()
          }
      }
    
    var savedChallengeIDs: [String]? {
          get {
            return UserDefaults.standard.value(forKey: "savedChallenges") as? [String]
          }
          set {
              UserDefaults.standard.set(newValue, forKey: "savedChallenges")
              UserDefaults.standard.synchronize()
          }
      }
    
    var completedWorkouts: [[String:Any]]? {
          get {
            return UserDefaults.standard.value(forKey: "completedWorkouts") as? [[String:Any]]
          }
          set {
              UserDefaults.standard.set(newValue, forKey: "completedWorkouts")
              UserDefaults.standard.synchronize()
          }
      }
    
    
    func setupUserInfoForLogin(data : [String: Any]) {
        if self.userId == nil || self.userId == ""{
            self.userId = data["uid"] as? String
        }
        self.fullName = data["name"] as? String
        self.userEmailAddress = data["emailAddress"] as? String
        self.profileImage = data["profileImage"] as? String
        self.gender = data["gender"] as? String
        self.location = data["location"] as? String
        self.workoutPlace = data["workoutPlace"] as? String
        self.birthday = data["birthday"] as? String
        self.skillLevel = data["skillLevel"] as? String
        self.headerImage = data["headerImage"] as? String
        self.savedWorkoutsIDs = data["saved_workouts"] as? [String]
        self.savedChallengeIDs = data["saved_challenges"] as? [String]

        self.currentWeight = data["current_weight"] as? String
        self.goalWeight = data["goal_weight"] as? String
        self.startWeight = data["start_weight"] as? String

        self.completedWorkouts = data["workout_Challenge"] as? [[String: Any]]
        
        self.isLoggedIn = true
    }
    
    var userId: String? {
        get {
            return UserDefaults.standard.string(forKey: "userId")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userId")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    
    var userEmailAddress: String? {
        get {
            return UserDefaults.standard.string(forKey: "userEmailAddress")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userEmailAddress")
            UserDefaults.standard.synchronize()
        }
    }
    
    var isLoggedIn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isLoggedIn")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isLoggedIn")
            UserDefaults.standard.synchronize()
        }
    }
    
  
    
    
 
    

    
    var password: String? {
        get {
            return UserDefaults.standard.string(forKey: "userpassword")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userpassword")
            UserDefaults.standard.synchronize()
        }
    }
    
    var birthday: String? {
        get {
            return UserDefaults.standard.string(forKey: "birthday")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "birthday")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    var gender: String? {
        get {
            return UserDefaults.standard.string(forKey: "gender")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "gender")
            UserDefaults.standard.synchronize()
        }
    }
    
    var location: String? {
        get {
            return UserDefaults.standard.string(forKey: "location")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "location")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    var lattitude: String? {
        get {
            return UserDefaults.standard.string(forKey: "lattitude")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "lattitude")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    var longtitude: String? {
        get {
            return UserDefaults.standard.string(forKey: "longtitude")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "longtitude")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    var skillLevel: String? {
        get {
            return UserDefaults.standard.string(forKey: "skillLevel")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "skillLevel")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    var currentWeight: String? {
        get {
            return UserDefaults.standard.string(forKey: "currentWeight")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "currentWeight")
            UserDefaults.standard.synchronize()
        }
    }
    
    var startWeight: String? {
        get {
            return UserDefaults.standard.string(forKey: "startWeight")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "startWeight")
            UserDefaults.standard.synchronize()
        }
    }
    
    var goalWeight: String? {
        get {
            return UserDefaults.standard.string(forKey: "goalWeight")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "goalWeight")
            UserDefaults.standard.synchronize()
        }
    }
    
    var workoutPlace: String? {
        get {
            return UserDefaults.standard.string(forKey: "workoutPlace")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "workoutPlace")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    var profileImage: String? {
        get {
            return UserDefaults.standard.string(forKey: "profileImage")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "profileImage")
            UserDefaults.standard.synchronize()
        }
    }
    
    var headerImage: String? {
        get {
            return UserDefaults.standard.string(forKey: "headerImage")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "headerImage")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    func clear() {
        self.token = nil
        self.userId = nil
        self.userEmailAddress = nil
        self.password = nil
        self.fullName = nil
        self.birthday = nil
        self.gender = nil
        self.location = nil
        self.profileImage = nil
        self.headerImage = nil
        self.skillLevel = nil
        self.workoutPlace = nil
        self.isLoggedIn = false
        self.savedWorkoutsIDs = nil
        self.currentWeight = nil
        self.goalWeight = nil
        self.startWeight = nil
        self.completedWorkouts = nil
        self.savedChallengeIDs = nil
        UserDefaults.standard.synchronize()
    }
}
