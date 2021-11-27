//
//  FIRMainCategoriesModel.swift
//  GrownStrong
//
//  Created by Aman on 16/09/21.
//

import Foundation
import FirebaseFirestore

class MainCategoriesModel :NSObject{
    var title = ""
    var id = ""
    var isSelected = false
    
    init(_ data : [String: Any], id : String){
        if let catTitle = data["categoryName"] as? String{
            self.title = catTitle
        }
        self.id = id
    }
    
    
}
