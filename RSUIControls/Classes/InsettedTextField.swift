//
//  InsettedTextField.swift
//  RSUIControls
//
//  Created by rsamsonov on 22.02.2021.
//

import UIKit

public class InsettedUITextField: UITextField {
    public var textInsets: UIEdgeInsets = .zero
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
}
