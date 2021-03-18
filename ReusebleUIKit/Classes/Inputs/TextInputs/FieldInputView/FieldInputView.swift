//
//  FieldInputView.swift
//  Parcel
//
//  Created by Skibin Alexander on 18.11.2020.
//  Copyright © 2020 Skibin Development. All rights reserved.
//

import UIKit

/// View элемент с 2мя textField
class FieldInputView: UIView, UIViewNibLoad, InputViewProtocol {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var field: UITextField!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    // MARK: - Public Properties
    
    public weak var delegate: InputViewDelegateProtocol?
    public var model: InputsModelProtocol!
    
    // MARK: - Private Properties
    
    internal var settings: InputsSettings = .init()
    internal var iconView: InputIconView = .instanceNib()
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure(settings: .init())
        
        field.delegate = self
        container.layer.cornerRadius = 10
        stackView.spacing = 16
    }
    
    // MARK: - Public Implementation
    
    public func configure(
        settings: InputsSettings = .init(),
        mode: UITextField.ViewMode = .never,
        keyboardType: UIKeyboardType = .default
    ) {
        self.settings = settings
        field.clearButtonMode = mode
        field.keyboardType = keyboardType
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
    
    /// Локальное поведение обновления UI
    private func localUpdateUI(with isFocus: Bool = false) {
        updateInputContainerFields()
        updatePlaceholderLabel()
        updatePlaceholderField()
        updateBorder(with: isFocus)
        updateIconUI()
    }
    
    // MARK: - InputViewProtocol
    
    func updateUI() {
        updateInputContainerFields()
        updatePlaceholderLabel()
        updatePlaceholderField()
        updateBorder()
        updateInputText()
        updateIconUI()
    }
    
    /// Начать ввод текста
    func beginEditing() {
        field.becomeFirstResponder()
    }
    
    /// Закончить ввод текста
    func endEditing() {
        field.resignFirstResponder()
    }
    
    func updateInputContainerFields() {
        switch model.state {
        case .present:
            container.backgroundColor = settings.background.emptyFields
        case .error:
            container.backgroundColor = settings.background.errorFields
        }
    }
    
    func updatePlaceholderLabel() {
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
                string: model.placeholder ?? "",
                attributes: [.foregroundColor: settings.placeholder.errorColor]
            )
            placeholderLabel.isHidden = false
        }
        
        placeholderLabel.attributedText = attributedPlaceholder
    }
    
    func updateBorder(with focus: Bool = false) {
        container.borderWidth = settings.border.width
        
        if focus {
            container.borderColor = settings.border.focusColor
        } else {
            let color = (model.text?.isEmpty ?? true) ?
                settings.border.emptyColor :
                settings.border.fillColor
            
            switch model.state {
            case .present:
                container.borderColor = color
            case .error:
                container.borderColor = settings.border.errorColor
            }
        }
    }
    
    func updatePlaceholderField() {
        let attributedPlaceholder: NSAttributedString
        
        switch model.state {
        case .present:
            attributedPlaceholder = NSAttributedString(
                string: model.placeholder ?? "",
                attributes: [.foregroundColor: settings.placeholder.emptyColor]
            )
        case .error:
            attributedPlaceholder = NSAttributedString(
                string: model.placeholder ?? "",
                attributes: [.foregroundColor: settings.placeholder.errorColor]
            )
        }
        
        field.attributedPlaceholder = attributedPlaceholder
    }
    
    func updateInputText() {
        field.attributedText = NSAttributedString(
            string: model.text ?? "",
            attributes: [.foregroundColor: settings.text.fillColor]
        )
    }
    
    func updateIconUI() {
        switch model.state {
        case .present where model.text?.isEmpty ?? true:
            iconView.updateUI(iconName: model.iconName, tint: settings.icon.textEmptyColor)
        case .present :
            iconView.updateUI(iconName: model.iconName, tint: settings.icon.textFillColor)
        case .error:
            iconView.updateUI(iconName: model.iconName, tint: settings.icon.textErrorColor)
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension FieldInputView: UITextFieldDelegate {
    
    func isBackspace(_ string: String) -> Bool {
        let char = string.cString(using: String.Encoding.utf8)!
        return strcmp(char, "\\b") == -92
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        /// Сброс ошибки
        model.state = settings.resetErrorWhenEditing ? .present : model.state
        
        /// Обновляем модель
        model.text = textField.text
        
        /// Вызов делегата
        delegate?.textDidBeginEditing(id: model.id)
        
        /// Обновляем UI
        localUpdateUI(with: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        /// Обновляем модель
        model.text = textField.text
        
        /// Вызов делегата
        delegate?.textDidEndEditing(id: model.id)
        
        /// Обновляем UI
        localUpdateUI(with: false)
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        
        guard delegate?.isReplace(
                id: model.id, textField.text,
                replaceString: string,
                range: range) ?? false else {
            return false
        }
        
        let copyMutableString = NSMutableString(string: textField.text ?? "")
        
        /// Собираем текст
        if isBackspace(string) {
            copyMutableString.deleteCharacters(in: range)
            model.text = copyMutableString as String
        } else {
            copyMutableString.insert(string, at: range.location)
            model?.text = copyMutableString as String
        }
        
        /// Сообщаем делегату об изменении цены
        delegate?.textDidChange(id: model.id)
        
        /// Сброс ошибки
        model.state = settings.resetErrorWhenEditing ? .present : model.state
        
        /// Обновляем UI
        localUpdateUI()
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = nil
        model.text = textField.text
        delegate?.textDidChange(id: model.id)
        localUpdateUI()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.shouldReturn(id: model.id) ?? true
    }
    
}
