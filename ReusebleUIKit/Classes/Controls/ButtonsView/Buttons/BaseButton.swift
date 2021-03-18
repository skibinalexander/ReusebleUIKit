//
//  BaseButton.swift
//  Parcel
//
//  Created by Skibin Alexander on 15.12.2020.
//  Copyright © 2020 Skibin Development. All rights reserved.
//

import UIKit

/// Контейнер кнопок для bottom
class BaseButton: UIView, UIViewNibLoad, ButtonsViewItem {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var button: UIButton!
    
    var title: String? {
        button.currentTitle
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - ButtonsViewItem
    
    func set(title: String?) {
        button.setTitle(title, for: .normal)
    }
    
    func setAvailableButton(_ isAvailable: Bool) {
        if isAvailable {
            button.isUserInteractionEnabled = true
            button.alpha = 1.0
        } else {
            button.isUserInteractionEnabled = false
            button.alpha = 0.35
        }
    }
    
    func setAction(target: Any, action: Selector) {
        button.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func set(id: String?) {
        button.accessibilityIdentifier = id
    }
    
}
