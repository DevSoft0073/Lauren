//
//  NotificationModel.swift
//  GrownStrong
//
//  Created by Aman on 03/09/21.
//

import Foundation
import FirebaseFirestore

class NotificationModel : NSObject{
    
    var type = ""
    var time = ""
    var messageText = ""
    var id = ""
    var status = 0
    
    init(_ data : [String: Any]){
        self.type = data["type"] as? String ?? ""
        self.id = data["id"] as? String ?? ""

        let stamp = data["timestamp"] as? Timestamp
        self.time = Date().getPastTime(for: stamp?.dateValue() ?? Date())
        self.messageText = data["title"] as? String ?? ""
        self.status = data["status"] as? Int ?? 0
    }
    
}
