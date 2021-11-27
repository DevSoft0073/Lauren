//
//  FIRLibraryHandler.swift
//  GrownStrong
//
//  Created by Aman on 08/09/21.
//

import Foundation
import FirebaseFirestore

enum LibraryMovementTypes{
    static let InstructionalMovements = "Instructional"
    static let DemoMovements = "Demo"
    static let ModificationalMovements = "Modify"

}


class FIRLibraryHandler: NSObject {
    var libraryRef = Firestore.firestore().collection("Library")
    var lastDocumentSnapshot: DocumentSnapshot!
//    var fetchingMore = false
    var movementsData : [HomeTrendingModel] = [HomeTrendingModel]()
    var mainCategoryData : [MovementCategoryModel] = [MovementCategoryModel]()

    
    func fetchMovementTypes(completionBlock : @escaping ((_ data : [MovementCategoryModel]) -> Void)){
        let ref = Firestore.firestore().collection("MovementsTypes")
        ref.getDocuments { (snapshot, err) in
            if err == nil{
                if !snapshot!.documents.isEmpty{
                    self.mainCategoryData.removeAll()
                    for data in snapshot!.documents{
                        self.mainCategoryData.append(MovementCategoryModel(data.data(), data.documentID))
                    }
                    completionBlock(self.mainCategoryData)
                }
            }
        }
    }
    
    
    func fetchMovementsInLibrary(completionBlock : @escaping ((_ data : [HomeTrendingModel]) -> Void)){
        
        var query: Query!
        
        if self.movementsData.isEmpty{
            query =  libraryRef.order(by: "TimeStamp").limit(to: 20)
        }else{
            query =  libraryRef.order(by: "TimeStamp").start(afterDocument: self.lastDocumentSnapshot).limit(to: 20)
        }
        
        query.getDocuments { (snapshot, err) in
            if err == nil{
                if !snapshot!.documents.isEmpty{
                    self.movementsData.removeAll()
                    self.lastDocumentSnapshot = snapshot?.documents.last
                    
                    for data in snapshot!.documents{
                        let dict = data.data()
                        self.movementsData.append(HomeTrendingModel(dict,workoutID: data.documentID))
                    }
                    completionBlock(self.movementsData)
                }
            }
        }
        
    }
    
}
