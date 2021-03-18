//
//  InputIconView.swift
//  Parcel
//
//  Created by Skibin Alexander on 25.11.2020.
//  Copyright © 2020 Skibin Development. All rights reserved.
//

import UIKit

class InputIconView: UIView, UIViewNibLoad {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var icon: UIImageView!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        icon.image = nil
        self.accessibilityIdentifier = InputIconView.className
    }
    
    // MARK: -
    
    public func updateUI(iconName: String?, tint: UIColor) {
        icon.image = UIImage(named: iconName)
        UIImage.imageView(view: icon, imageName: iconName, tint: tint)
    }
    
}
