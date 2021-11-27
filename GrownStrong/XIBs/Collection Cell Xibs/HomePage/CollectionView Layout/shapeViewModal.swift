//
//  shapeViewModal.swift
//  nuZZle App
//
//  Created by Aman on 30/11/20.
//  Copyright © 2020 Rapid Softs. All rights reserved.
//


import UIKit
import CollectionViewPagingLayout

class ShapesViewModel {
    
    // MARK: Static Properties
    
    private(set) static var scaleOptions: ScaleTransformViewOptions = .init()
    private(set) static var stackOptions: StackTransformViewOptions = .init()
    private(set) static var snapshotOptions: SnapshotTransformViewOptions = .init()
    
    
    // MARK: Properties

    
    var selectedLayout: LayoutTypeCellViewModel {
        didSet {
            if let options = selectedLayout.layout.scaleOptions {
                ShapesViewModel.scaleOptions = options
            } else if let options = selectedLayout.layout.stackOptions {
                ShapesViewModel.stackOptions = options
            } else if let options = selectedLayout.layout.snapshotOptions {
                ShapesViewModel.snapshotOptions = options
            }
        }
    }
    var layoutTypeViewModels: [LayoutTypeCellViewModel]
    let showBackButton: Bool
    let showPageControl: Bool
    
    
    // MARK: Lifecycle
    
    init(layouts: [ShapeLayout], showBackButton: Bool = true, showPageControl: Bool = false,cards :[ShapeCardViewModel] = []) {
        ShapesViewModel.allLayoutViewModes = [.init(layout: .scaleBlur, iconName: "", title: "", subtitle: "", cardViewModels: cards)]
        
        self.showBackButton = showBackButton
        self.showPageControl = showPageControl
        self.layoutTypeViewModels = layouts.compactMap { layout in
            ShapesViewModel.allLayoutViewModes.first {
                $0.layout == layout
            }
        }
        selectedLayout = layoutTypeViewModels.first!
    }
    
    
    // MARK: Public functions
    
    func setCustomOptions<T>(_ options: T) {
        if let options = options as? ScaleTransformViewOptions {
            ShapesViewModel.scaleOptions = options
        } else if let options = options as? StackTransformViewOptions {
            ShapesViewModel.stackOptions = options
        } else if let options = options as? SnapshotTransformViewOptions {
            ShapesViewModel.snapshotOptions = options
        }
    }
}


extension ShapesViewModel {

   static var allLayoutViewModes: [LayoutTypeCellViewModel] = [
    .init(layout: .scaleLinear,
                 iconName: "scale_normal",
                 title: "Scale",
                 subtitle: "Linear",
                 cardViewModels: generateCardViewModels())
    ]
    //else removed all effects

    private static func generateCardViewModels() -> [ShapeCardViewModel] {
//        var userListModel = [userList]()
        
        
        var list : [Shape] = []

        for _ in 0..<4{
            list.append(Shape(name: "", address: "", age:  "", img:  "img3"))
        }
        
//        let shapes: [Shape] = [
//        .init(name: "Kira", address: "New York City", age: "27 years old", img: "1"),
//        .init(name: "Eliza", address: "New York City", age: "27 years old", img: "2"),
//        .init(name: "Amelia", address: "New York City", age: "27 years old", img: "3"),
//        .init(name: "Alice", address: "New York City", age: "27 years old", img: "4"),
//        .init(name: "Sophia", address: "New York City", age: "27 years old", img: "5"),
//        .init(name: "Emma", address: "New York City", age: "27 years old", img: "6"),
//        .init(name: "Charlotte", address: "New York City", age: "27 years old", img: "7")
//        ]
        return list.map {
            ShapeCardViewModel(image: $0.img, userName: $0.name, age: $0.age, address: $0.address)
        }
    }
}

struct Shape {
    let name: String
    let address: String
    let age : String
    let img : String
}
