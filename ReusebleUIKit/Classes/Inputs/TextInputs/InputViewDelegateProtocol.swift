//
//  ReusebleInputView.swift
//  Parcel
//
//  Created by Скибин Александр on 20.01.2021.
//  Copyright © 2021 Skibin Development. All rights reserved.
//

import Foundation

public protocol InputViewDelegateProtocol: class {
    func textDidBeginEditing(id: String?)
    func textDidEndEditing(id: String?)
    func textDidChange(id: String?)
    func shouldReturn(id: String?) -> Bool
    func isReplace(
        id: String?,
        _ currentString: String?,
        replaceString: String,
        range: NSRange
    ) -> Bool
}

public extension InputViewDelegateProtocol {
    func textDidBeginEditing(id: String?) {}
    func textDidEndEditing(id: String?) {}
    func textDidChange(id: String?) {}
    func shouldReturn(id: String?) -> Bool { true }
    func isReplace(
        id: String?,
        _ currentString: String?,
        replaceString: String,
        range: NSRange
    ) -> Bool { true }
}
