//
//  InputsModel.swift
//  Parcel
//
//  Created by Skibin Alexander on 25.11.2020.
//  Copyright © 2020 Skibin Development. All rights reserved.
//

import Foundation

/// Описание модели InputsViews
public protocol InputsModelProtocol: class {
    
    /// Идентификатор
    var id: String? { get set }
    
    /// Подсказка
    var placeholder: String? { get set }
    
    /// Путь, название изображения
    var iconName: String? { get set }
    
    /// Текст введеный
    var text: String? { get set }
    
    /// Описание ошибки
    var error: String? { get set }
    
    /// Состояние
    var state: InputsState { get set }
    
}

/// Базовая реализация модели InputsViews
public class InputsModel: InputsModelProtocol {
    public var id: String?
    public var placeholder: String?
    public var iconName: String?
    public var text: String?
    public var error: String?
    public var state: InputsState = .present
}
