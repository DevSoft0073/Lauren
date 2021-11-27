//
//  ShapeCardView.swift
//  CollectionViewPagingLayout
//
//  Created by Amir Khorsandi on 2/16/20.
//  Copyright © 2020 Amir Khorsandi. All rights reserved.
//

import UIKit
//import PINRemoteImage

class ShapeCardView: UIView, NibBased {
    
    // MARK: Properties
    
    var viewModel: ShapeCardViewModel? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLbl: UILabel!
    @IBOutlet weak var ageAddressLbl: UILabel!
    
    
    // MARK: UICollectionViewCell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    
    // MARK: Private functions
    
    private func setupViews() {
        set(startPoint: .zero, endPoint: CGPoint(x: 1, y: 1))
//        self.imageView.layer.cornerRadius = 15
//        self.imageView.clipsToBounds = true
    }
    
    private func updateViews() {
        
//        nameLbl.text = viewModel?.userName
//        imageView.pin_setImage(from: URL(string: viewModel?.image ?? "1"), placeholderImage: UIImage(named: "1"))
//        ageAddressLbl.text = "\(viewModel?.age ?? "")years old"
        imageView.image = UIImage(named: "img3")
    }
    
    
    
      override class var layerClass: Swift.AnyClass {
          CAGradientLayer.self
      }
      
      override var layer: CAGradientLayer {
          (super.layer as? CAGradientLayer)!
      }
      
      
      // MARK: Public functions
      
      public func set(colors: [UIColor]) {
          backgroundColor = .clear
          layer.colors = colors.map { $0.cgColor }
      }
      
      public func set(startPoint: CGPoint, endPoint: CGPoint) {
          layer.startPoint = startPoint
          layer.endPoint = endPoint
      }
    
}
