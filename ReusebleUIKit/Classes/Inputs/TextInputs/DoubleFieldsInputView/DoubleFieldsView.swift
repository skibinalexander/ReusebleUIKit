//
//  DoubleFieldsView.swift
//  Parcel
//
//  Created by Skibin Alexander on 18.11.2020.
//  Copyright © 2020 Skibin Development. All rights reserved.
//

import UIKit

/// Output протокол для DoubleFieldsView
protocol DoubleFieldsViewDelegate: class {
    func textFieldDidBeginEditing(text: String?, fieldType: DoubleFieldsView.FieldType)
    func textFieldDidEndEditing(text: String?, fieldType: DoubleFieldsView.FieldType)
}

/// View элемент с 2мя textField
class DoubleFieldsView: UIView {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var firstContainer: UIView!
    @IBOutlet private weak var secondContainer: UIView!
    
    @IBOutlet private weak var firstField: UITextField!
    @IBOutlet private weak var secondField: UITextField!
    
    @IBOutlet private weak var firstPlaceholderLabel: UILabel!
    @IBOutlet private weak var secondPlaceholderLabel: UILabel!
    
    // MARK: - Public Properties
    
    public weak var delegate: DoubleFieldsViewDelegate?
    
    // MARK: - Private Properties
    
    private var state: State = .present
    private var settings: Settings = .init()
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
        
        firstField.text = nil
        secondField.text = nil
        
        firstField.delegate = self
        secondField.delegate = self
    }
    
    // MARK: - Public Implementation
    
    public func configure(settings: Settings = .init(), state: State = .present) {
        self.settings = settings
        self.state = state
    }
    
    public func configureUI(with configurator: Configure) {
        updateUI(with: configurator)
    }
    
    public func updateUI(with configurator: Configure, for newState: State) {
        configure(settings: self.settings, state: newState)
        updateUI(with: configurator)
    }
    
    // MARK: - Private Implementation
    
    private func updateUI(with configurator: Configure) {
        updatePlaceholder(text: configurator.placeholder)
    }
    
    private func updateBackgroundFields() {
        switch state {
        case .present:
            firstContainer.backgroundColor = settings.backgroundEmptyFields
            secondContainer.backgroundColor = settings.backgroundEmptyFields
        case .error:
            firstContainer.backgroundColor = settings.backgroundErrorFields
            secondContainer.backgroundColor = settings.backgroundErrorFields
        }
    }
    
    private func updatePlaceholder(text: String?) {
        
        let attributedPlaceholder: NSAttributedString
        
        switch state {
        case .present:
            attributedPlaceholder = NSAttributedString(
                string: text ?? "",
                attributes: [.foregroundColor: settings.placeholderEmptyColor]
            )
        case .error:
            attributedPlaceholder = NSAttributedString(
                string: text ?? "",
                attributes: [.foregroundColor: settings.placeholderErrorColor]
            )
        }
        
        firstField.attributedPlaceholder = attributedPlaceholder
        secondField.attributedPlaceholder = attributedPlaceholder
        
        firstPlaceholderLabel.attributedText = attributedPlaceholder
        secondPlaceholderLabel.attributedText = attributedPlaceholder
        
    }
    
    private func updateField(text: String?) {
        switch state {
        case .present:
            firstField.attributedText = NSAttributedString(
                string: text ?? "",
                attributes: [.foregroundColor: settings.placeholderEmptyColor]
            )
        case .error:
            firstField.attributedPlaceholder = NSAttributedString(
                string: text ?? "",
                attributes: [.foregroundColor: settings.placeholderErrorColor]
            )
        }
    }
    
    private func checkFieldType(for textField: UITextField) -> FieldType {
        if textField == firstField {
            return .left
        } else if textField == secondField {
            return .right
        }
        
        return .undefined
    }
    
}

// MARK: - UITextFieldDelegate

extension DoubleFieldsView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldDidBeginEditing(
            text: textField.text,
            fieldType: checkFieldType(for: textField)
        )
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing(
            text: textField.text,
            fieldType: checkFieldType(for: textField)
        )
    }
    
}

// MARK: - Дополнительные структуры данных для DoubleFieldsView

extension DoubleFieldsView {
    
    /// Enum состояния View
    enum State {
        
        /// Стандартное состояние
        case present
        
        /// Состояние ошибки
        case error
        
    }
    
    /// Enum определения textField
    enum FieldType {
        
        /// Поле не определено
        case undefined
        
        /// Левое поле
        case left
        
        /// Правое поле
        case right
    }
    
    /// Модель настроек для View
    struct Settings {
        
        /// Background цвет контейнера View в обычном состоянии
        var backgroundEmptyFields: UIColor = .gray
        
        /// Background цвет контейнера View в состоянии ошибки
        var backgroundErrorFields: UIColor = .red
        
        /// Цвет текста для placeholder в обычном состоянии
        var placeholderEmptyColor: UIColor = .gray
        
        /// Цвет текста для placeholder в состоянии ошибки
        var placeholderErrorColor: UIColor = .red
        
        /// Сброс отображения состояния ошибки при редактировании
        var resetErrorWhenEditing: Bool = true
        
        /// Цвет текста для field в обычном состоянии
        var textFillColor: UIColor = .black
        
        /// Цвет текста для состояния ошибки
        var textErrorColor: UIColor = .red
        
        /// Показывать кнопку очистить для textField
        var textFieldClear: Bool = true
        
    }
    
    /// Модель конфигурации
    struct Configure {
        let placeholder: String?
        let text: String?
        let error: String?
    }
    
}
