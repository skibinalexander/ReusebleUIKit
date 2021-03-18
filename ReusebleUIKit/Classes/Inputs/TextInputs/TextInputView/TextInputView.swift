//
//  TextInputView.swift
//  Parcel
//
//  Created by Skibin Alexander on 18.11.2020.
//  Copyright © 2020 Skibin Development. All rights reserved.
//

import UIKit

/// View элемент с 2мя textField
class TextInputView: UIView, UIViewNibLoad, InputViewProtocol {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var container: UIView!
    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var placeholderLabel: UILabel!
    
    // MARK: - Public Properties
    
    public weak var delegate: InputViewDelegateProtocol?
    public var model: InputsModelProtocol!
    
    // MARK: - Private Properties
    
    internal var settings: InputsSettings = .init()
    internal var iconView: InputIconView = .instanceNib()
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
        
        container.layer.cornerRadius = 10
        textView.textContainerInset = UIEdgeInsets(top: 18, left: -4, bottom: 16, right: 12)
        textView.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textView.centerVertically()
    }
    
    // MARK: - Public Implementation
    
    public func configure(settings: InputsSettings = .init()) {
        self.settings = settings
    }
    
    public func configure(model: InputsModelProtocol) {
        guard self.model == nil else {
            self.model = InputsModel()
            updateUI()
            return
        }

        self.model = model

        updateUI()
    }
    
    // MARK: - InputViewProtocol
    
    func updateUI() {
        updateInputContainerFields()
        updatePlaceholderLabel()
        updateInputText()
        updateIconUI()
    }
    
    func beginEditing() {
        textView.becomeFirstResponder()
    }
    
    func endEditing() {
        textView.resignFirstResponder()
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
        case .error:
            attributedPlaceholder = NSAttributedString(
                string: model.placeholder ?? "",
                attributes: [.foregroundColor: settings.placeholder.errorColor]
            )
        }
        
        placeholderLabel.attributedText = attributedPlaceholder
        placeholderLabel.isHidden = model.text?.isEmpty ?? true
    }
    
    func updateInputText() {
        let attributedText: NSAttributedString
        let font = FontFamily.SFProDisplay.medium.font(size: 15)
        
        switch model.state {
        case .present where model.text?.isEmpty ?? true:
            attributedText = NSAttributedString(
                string: model.placeholder ?? "",
                attributes: [
                    .foregroundColor : settings.placeholder.emptyColor,
                    .font: font
                ]
            )
        case .present:
            attributedText = NSAttributedString(
                string: model.text ?? "",
                attributes: [
                    .foregroundColor : settings.text.fillColor,
                    .font: font
                ]
            )
        case .error:
            attributedText = NSAttributedString(
                string: model.error ?? "",
                attributes: [
                    .foregroundColor : settings.placeholder.errorColor,
                    .font: font
                ]
            )
        }
        
        textView.attributedText = attributedText
        layoutIfNeeded()
    }
    
    func updateIconUI() {
        switch model.state {
        case .present where model.text?.isEmpty ?? true:
            updateUI(iconName: model.iconName, tint: settings.icon.textEmptyColor)
        case .present:
            updateUI(iconName: model.iconName, tint: settings.icon.textFillColor)
        case .error:
            updateUI(iconName: model.iconName, tint: settings.icon.textErrorColor)
        }
    }
    
    // MARK: - Private Implementation
    
    /// Локальное поведение обновления UI
    private func localUpdateUI() {
        updateInputContainerFields()
        updatePlaceholderLabel()
        updateColorText()
        updateIconUI()
    }
    
    private func updateColorText() {
        if model.state == .present {
            if model.text?.isEmpty ?? true {
                textView.textColor = settings.placeholder.emptyColor
            } else {
                textView.textColor = settings.text.fillColor
            }
        }
    }
    
    private func updateUI(iconName: String?, tint: UIColor) {
        icon.image = UIImage(named: iconName)
        UIImage.imageView(view: icon, imageName: iconName, tint: tint)
    }
    
}

// MARK: - UITextFieldDelegate

extension TextInputView: UITextViewDelegate {
    
    func isBackspace(_ string: String) -> Bool {
        let char = string.cString(using: String.Encoding.utf8)!
        return strcmp(char, "\\b") == -92
    }
    
    func isNewLine(_ string: String) -> Bool {
        return string == "\n"
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        /// Сброс ошибки
        model.state = settings.resetErrorWhenEditing ? .present : model.state
        
        if model.text?.isEmpty ?? true {
            textView.text = nil
        }
        
        /// Обновляем UI
        localUpdateUI()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        model.text = textView.text
        delegate?.textDidChange(id: model.id)
        
        /// Обновляем UI
        localUpdateUI()
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        updateUI()
        return delegate?.shouldReturn(id: model.id) ?? true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard delegate?.isReplace(
            id: model.id,
            textView.text,
            replaceString: text,
            range: range
        ) ?? false else {
            return false
        }
        
        let copyMutableString = NSMutableString(string: textView.text ?? "")
        
        /// Собираем текст
        if isBackspace(text) {
            copyMutableString.deleteCharacters(in: range)
            model.text = copyMutableString as String
        } else if isNewLine(text) {
            textView.resignFirstResponder()
        } else {
            copyMutableString.insert(text, at: range.location)
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
    
}
