//
//  DoubleSelectButtonsIconsView.swift
//  Parcel
//
//  Created by Skibin Alexander on 18.11.2020.
//  Copyright © 2020 Skibin Development. All rights reserved.
//

import UIKit

/// Output протокол для DoubleSelectButtonsIconsView
protocol DoubleButtonsInputsViewDelegate: class {
    func doubleSelectButtonDidTouch(id: String?, type: DoubleButtonsInputsView.ButtonType)
}

/// View элемент с 2мя textField
class DoubleButtonsInputsView: UIView, UIViewNibLoad {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var stackView: UIStackView!
    
    // MARK: - Public Properties
    
    public weak var delegate: DoubleButtonsInputsViewDelegate?
    public var firstModel: InputsModelProtocol!
    public var secondModel: InputsModelProtocol!
    public var id: String?
    
    // MARK: - Private Properties
    
    private var firstButton = ButtonInputView.instanceNib()
    private var secondButton = ButtonInputView.instanceNib()
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
        stackView.addArrangedSubview(firstButton)
        stackView.addArrangedSubview(secondButton)
    }
    
    // MARK: - Public Implementation
    
    public func configure(settings: InputsSettings = .init()) {
        firstButton.configure(settings: settings)
        secondButton.configure(settings: settings)
    }
    
    public func configure(
        firstModel: InputsModelProtocol,
        secondModel: InputsModelProtocol,
        firstDelegate: ButtonInputViewDelegateProtocol?,
        secondDelegate: ButtonInputViewDelegateProtocol?
    ) {
        firstButton.configure(model: firstModel)
        secondButton.configure(model: secondModel)
        
        firstButton.delegate = firstDelegate
        secondButton.delegate = secondDelegate
    }
    
    public func updateUI() {
        updateFirstUI()
        updateSecondUI()
    }
    
    public func updateFirstUI() {
        firstButton.updateUI()
    }
    
    public func updateSecondUI() {
        secondButton.updateUI()
    }
    
}

// MARK: - Дополнительные структуры данных для DoubleSelectButtonsIconsView

extension DoubleButtonsInputsView {
    
    /// Enum определения textField
    enum ButtonType {
        
        /// Поле не определено
        case undefined
        
        /// Левое поле
        case left
        
        /// Правое поле
        case right
    }
}

// MARK: - SelectButtonViewDelegate

extension DoubleButtonsInputsView: ButtonInputViewDelegateProtocol {
    
    func buttonInputDidTouch(id: String?) {
        if id == firstModel?.id {
            delegate?.doubleSelectButtonDidTouch(id: self.id, type: .left)
        }
        
        if id == secondModel?.id {
            delegate?.doubleSelectButtonDidTouch(id: self.id, type: .right)
        }
    }
    
}
