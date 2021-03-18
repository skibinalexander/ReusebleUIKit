//
//  ButtonInputView.swift
//  Parcel
//
//  Created by Skibin Alexander on 22.11.2020.
//  Copyright © 2020 Skibin Development. All rights reserved.
//

import UIKit

/// Output протокол для ButtonInputView
public protocol ButtonInputViewDelegateProtocol: class {
    func buttonInputDidTouch(id: String?)
}

/// View элемент с 2мя textField
class ButtonInputView: UIView, UIViewNibLoad {
    
    // MARK: - IBOutlets
    
    @IBOutlet public weak var container: UIView!
    @IBOutlet public weak var stackView: UIStackView!
    @IBOutlet public weak var button: UIButton!
    @IBOutlet public weak var placeholderLabel: UILabel!
    
    // MARK: - Public Properties
    
    public weak var delegate: ButtonInputViewDelegateProtocol?
    public var model: InputsModelProtocol!
    
    // MARK: - Private Properties
    
    internal var settings: InputsSettings = .init()
    internal var iconView: InputIconView = .instanceNib()
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        container.layer.cornerRadius = 10
        stackView.spacing = 16
        button.setTitle(nil, for: .normal)
    }
    
    // MARK: - Public Implementation
    
    public func configure(settings: InputsSettings = .init()) {
        self.settings = settings
    }
    
    public func configure(model: InputsModelProtocol) {
        guard self.model == nil else {
            updateUI()
            return
        }
        
        self.model = model
        
        if !(model.iconName?.isEmpty ?? true) {
            configureIcon()
        }
        
        updateUI()
    }
    
    public func updateUI() {
        updateBackgroundFields()
        updatePlaceholder()
        updateButton()
        updateIconUI()
    }
    
    // MARK: - Private Implementation
    
    private func configureIcon() {
        guard stackView.subviews.first(
            where: { $0.accessibilityIdentifier == InputIconView.className }
        ) == nil else {
            return
        }
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        iconView.snp.makeConstraints { (make) in
            make.height.equalTo(56)
            make.width.equalTo(24)
        }
        
        stackView.insertArrangedSubview(iconView, at: 0)
    }
    
    private func updateBackgroundFields() {
        switch model.state {
        case .present:
            container.backgroundColor = settings.background.emptyFields
        case .error:
            container.backgroundColor = settings.background.errorFields
        }
    }
    
    private func updatePlaceholder() {
        
        let attributedPlaceholder: NSAttributedString
        
        switch model.state {
        case .present:
            attributedPlaceholder = NSAttributedString(
                string: model.placeholder ?? "",
                attributes: [.foregroundColor: settings.placeholder.emptyColor]
            )
            
            placeholderLabel.isHidden = model.text?.isEmpty ?? true
        case .error:
            attributedPlaceholder = NSAttributedString(
                string: model.error ?? "",
                attributes: [.foregroundColor: settings.placeholder.errorColor]
            )
            placeholderLabel.isHidden = false
        }
        
        placeholderLabel.attributedText = attributedPlaceholder
    }
    
    private func updateButton() {
        let attributedTitle: NSAttributedString
        
        switch model.state {
        case .present where model.text?.isEmpty ?? true:
            attributedTitle = NSAttributedString(
                string: model.placeholder ?? "",
                attributes: [.foregroundColor: settings.placeholder.emptyColor]
            )
        case .present:
            attributedTitle = NSAttributedString(
                string: model.text ?? "",
                attributes: [.foregroundColor: settings.text.fillColor]
            )
        case .error where model.text?.isEmpty ?? true:
            attributedTitle = NSAttributedString(
                string: model.placeholder ?? "",
                attributes: [.foregroundColor: settings.text.errorColor]
            )
        case .error:
            attributedTitle = NSAttributedString(
                string: model.text ?? "",
                attributes: [.foregroundColor: settings.text.errorColor]
            )
        }
        
        button.setAttributedTitle(
            attributedTitle,
            for: .normal
        )
    }
    
    private func updateIconUI() {
        switch model.state {
        case .present where model.text?.isEmpty ?? true:
            iconView.updateUI(iconName: model.iconName, tint: settings.icon.textEmptyColor)
        case .present :
            iconView.updateUI(iconName: model.iconName, tint: settings.icon.textFillColor)
        case .error:
            iconView.updateUI(iconName: model.iconName, tint: settings.icon.textErrorColor)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func actionButtonDidTouch(_ sender: UIButton) {
        delegate?.buttonInputDidTouch(id: model.id)
    }
    
}
