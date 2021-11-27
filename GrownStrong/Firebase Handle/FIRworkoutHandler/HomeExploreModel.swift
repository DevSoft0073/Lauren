//
//  HomeExploreModel.swift
//  GrownStrong
//
//  Created by Aman on 31/08/21.
//

import Foundation

class HomeExploreModel : NSObject{
    var title = ""
    var time = ""
    var id = ""
    var img = ""
    var type = ""
    var descriptionText = ""
    init(_ data : [String: Any]){
        self.title = data["Title"] as? String ?? ""
        self.time = data["Time"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.img = data["Image"] as? String ?? ""
        self.type = data["Type"] as? String ?? ""
        self.descriptionText = data["Description"] as? String ?? ""
    }
}
