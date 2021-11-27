//
//  MovementCategoryModel.swift
//  GrownStrong
//
//  Created by Aman on 16/09/21.
//

import Foundation
import FirebaseFirestore

class MovementCategoryModel : NSObject{
    var id = ""
    var name = ""
    var isSelected = false
    
    init(_ data: [String: Any] ,_ id : String){
        self.id = id
        if let name = data["name"] as? String{
            self.name = name
        }
    }
}
