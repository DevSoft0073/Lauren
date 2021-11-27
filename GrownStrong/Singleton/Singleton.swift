//
//  Singleton.swift
//  GrownStrong
//
//  Created by Aman on 26/07/21.
//

import Foundation
import UIKit

class Singleton {
    
    static let shared = Singleton()//also use for first time signup process
    
    var name = ""
    var emailAddress = ""
    var password = ""
    var profileImage : UIImage?
    var gender = ""
    var location = ""
    var workoutPlace = ""
    var birthday = ""
    var skillLevel = ""
    var currentWeight = ""
    var goalWeight = ""

    var isProfileImageSelected = false
    
}
