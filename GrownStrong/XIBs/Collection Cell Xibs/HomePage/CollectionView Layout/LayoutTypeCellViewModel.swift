//
//  LayoutTypeCellViewModel.swift
//  nuZZle App
//
//  Created by Aman on 30/11/20.
//  Copyright © 2020 Rapid Softs. All rights reserved.
//

import Foundation

struct LayoutTypeCellViewModel {
    
    // MARK: Properties
    
    let layout: ShapeLayout
    let iconName: String
    let title: String
    let subtitle: String
    var cardViewModels: [ShapeCardViewModel]
}
