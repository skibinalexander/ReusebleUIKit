//
//  InputViewProtocol.swift
//  Parcel
//
//  Created by Скибин Александр on 21.01.2021.
//  Copyright © 2021 Skibin Development. All rights reserved.
//

import Foundation

/// Интерфейс файла ввода текста
protocol InputViewProtocol {
    
    func updateUI()
    
    /// Начать ввод текста
    func beginEditing()
    
    /// Закончить ввод текста
    func endEditing()
    
    /// Обновить состояние контейнера ввода текста
    func updateInputContainerFields()
    
    /// Обновить состояние placeholder
    func updatePlaceholderLabel()
    
    /// Обновить значение текста и inpute text
    func updateInputText()
    
    /// Обновить состояние иконки
    func updateIconUI()
    
}
