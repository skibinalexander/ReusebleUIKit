//
//  InputsSettings.swift
//  Parcel
//
//  Created by Skibin Alexander on 25.11.2020.
//  Copyright © 2020 Skibin Development. All rights reserved.
//

import UIKit

/// Модель настроек для Inputs View
struct InputsSettings {
    
    struct Backoround {
        /// Background цвет контейнера View в обычном состоянии
        var emptyFields: UIColor = .gray
        
        /// Background цвет контейнера View в состоянии ошибки
        var errorFields: UIColor = .red
    }
    
    struct Placeholder {
        /// Цвет текста для placeholder в обычном состоянии
        var emptyColor: UIColor = .gray
        
        /// Цвет текста для placeholder в состоянии ошибки
        var errorColor: UIColor = .red
    }
    
    struct Border {
        
        /// Цвет для border в обычном состоянии
        var emptyColor: UIColor = .clear
        
        /// Цвет, когда поле в фокусе
        var focusColor: UIColor = .clear
        
        /// Цвет для border когда поле заполнено
        var fillColor: UIColor = .clear
        
        /// Цвет для border в состоянии ошибки
        var errorColor: UIColor = .clear
        
        var width: CGFloat = .zero
        
    }
    
    struct Text {
        /// Цвет текста для field в обычном состоянии
        var fillColor: UIColor = .black
        
        /// Цвет текста для состояния ошибки
        var errorColor: UIColor = .red
    }
    
    struct Icon {
        /// Цвет иконки заполненного текста
        var textFillColor: UIColor = .black
        
        /// Цвет иконки не заполненного текста
        var textEmptyColor: UIColor = .gray
        
        /// Цвет иконки ошибки
        var textErrorColor: UIColor = .red
    }
    
    // MARK: - Properties
    
    var background: Backoround = .init()
    
    var placeholder: Placeholder = .init()
    
    var border: Border = .init()
    
    var text: Text = .init()
    
    var icon: Icon = .init()
    
    /// Сброс отображения состояния ошибки при редактировании
    var resetErrorWhenEditing: Bool = true
    
}
