//
//  ButtonsView.swift
//  Parcel
//
//  Created by Skibin Alexander on 15.12.2020.
//  Copyright © 2020 Skibin Development. All rights reserved.
//

import SnapKit
import UIKit

/// Делегат для View
public protocol ButtonsViewDelegateProtocol: class {
    
    /// Евент нажатия кнопки по индексу
    /// - Parameter index: Индекс нажатия
    func buttonDidTouch(at index: Int)
    
    
    /// Евент нажатие кнопки
    /// - Parameters:
    ///   - id: Идентификатор buttonsView
    ///   - index: Индекс нажатия
    func buttonDidTouch(with id: String?, at index: Int)
    
}

public extension ButtonsViewDelegateProtocol {
    func buttonDidTouch(with id: String?, at index: Int) {}
}

/// Item для кнопки buttonsView
public protocol ButtonsViewItem {
    var title: String? { get }
    
    func set(title: String?)
    func setAvailableButton(_ isAvailable: Bool)
    func setAction(target: Any, action: Selector)
    func set(id: String?)
}

/// Контейнер кнопок для bottom
public final class ButtonsView: UIView, UIViewNibLoad {
    
    // MARK: - Types
    
    enum ButtonType {
        case round(String)
        case outline(String)
        case desctructive(String)
        case base(String)
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var stackView: UIStackView! {
        didSet {
            stackView.distribution = .fillEqually
            stackView.alignment = .center
            stackView.axis = .vertical
            stackView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    // MARK: - Public Properties
    
    public var id: String?
    public weak var delegate: ButtonsViewDelegateProtocol!
    public var buttonViewItems: [ButtonsViewItem] {
        stackView.arrangedSubviews as? [ButtonsViewItem] ?? []
    }
    
    // MARK: - Lifecycle
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func layoutSubviews() {
        stackView.arrangedSubviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: stackView.width).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 76.0).isActive = true
        }
    }
    
    // MARK: - ConfigureUI
    
    public func configureView(
        id: String? = nil,
        on view: UIView,
        bottomOffset: ConstraintOffsetTarget = 0,
        delegate: ButtonsViewDelegateProtocol?) {
        
        view.addSubview(self)
        
        self.snp.makeConstraints { (make) in
            make.top.equalTo(stackView)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(bottomOffset)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
        }
        
        self.delegate = delegate
    }
    
    public func configureUI(
        with buttons: [ButtonType]) {
        
        buttons.enumerated().forEach {
            stackView.addArrangedSubview(
                factoryButtons(for: $1, at: $0)
            )
        }
        
    }
    
    public func updateAvailable(state: Bool, at index: Int) {
        guard let buttonItem = stackView.arrangedSubviews[index] as? ButtonsViewItem  else {
            return
        }
        
        buttonItem.setAvailableButton(state)
    }
    
    public func updateButton(title: String?, at index: Int) {
        guard let buttonItem = stackView.arrangedSubviews[index] as? ButtonsViewItem  else {
            return
        }
        
        buttonItem.set(title: title)
    }
    
    public func removeAllButtons() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    // MARK: - Factory Buttons
    
    private func factoryButtons(for type: ButtonType, at index: Int) -> UIView {
        let buttonItem: UIView & ButtonsViewItem
        
        switch type {
        case .round(let title):
            buttonItem = RoundButton.instanceNib()
            buttonItem.set(title: title)
        case .outline(let title):
            buttonItem = OutlineButton.instanceNib()
            buttonItem.set(title: title)
        case .desctructive(let title):
            buttonItem = DestructiveButton.instanceNib()
            buttonItem.set(title: title)
        case .base(let title):
            buttonItem = BaseButton.instanceNib()
            buttonItem.set(title: title)
        }
        
        buttonItem.setAvailableButton(true)
        buttonItem.set(id: String(index))
        buttonItem.setAction(target: self, action: #selector(buttonItemAction(_:)))
        
        return buttonItem
    }
    
    // MARK: - Actions
    
    @objc func buttonItemAction(_ sender: UIView) {
        guard let index = Int(sender.accessibilityIdentifier ?? "") else {
            return
        }
        
        delegate?.buttonDidTouch(at: index)
        delegate?.buttonDidTouch(with: id, at: index)
    }
    
}
