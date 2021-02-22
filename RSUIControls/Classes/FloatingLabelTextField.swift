//
//  FloatingLabelTextField.swift
//  RSUIControls
//
//  Created by rsamsonov on 22.02.2021.
//

import UIKit

public class FloatingLabelTextField: UIView {
    public enum ValidityState {
        case normal
        case active
        case error
    }
    public enum SecurityState {
        case none
        case secure(withButton: Bool)
    }
    
    public var validityState: ValidityState = .normal {
        didSet {
            switch validityState {
            case .normal:
                titleLabel.textColor = titleColor
                if let borderColor = borderColor {
                    textField.layer.borderColor = borderColor.cgColor
                }
            case .active:
                titleLabel.textColor = activeTitleColor
                if let activeBorderColor = activeBorderColor {
                    textField.layer.borderColor = activeBorderColor.cgColor
                }
            case .error:
                titleLabel.textColor = errorTitleColor
                if let borderColor = errorBorderColor {
                    textField.layer.borderColor = borderColor.cgColor
                }
            }
        }
    }
    
    public var securityState: SecurityState = .none {
        didSet {
            switch securityState {
            case .none:
                textField.isSecureTextEntry = false
            case .secure:
                textField.isSecureTextEntry = true
            }
            updateButtonVisibility()
        }
    }
    
    public var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
            updateTitleVisibility(animated: false)
        }
    }
    
    @IBInspectable
    public var titleColor: UIColor?
    
    @IBInspectable
    public var activeTitleColor: UIColor?
    
    @IBInspectable
    public var errorTitleColor: UIColor?
    
    @IBInspectable
    public var borderColor: UIColor?
    
    @IBInspectable
    public var activeBorderColor: UIColor?
    
    @IBInspectable
    public var errorBorderColor: UIColor?
    
    @IBInspectable
    @available(iOS 10.0, *)
    public var textContentType: UITextContentType {
        get {
            return textField.textContentType
        }
        set {
            textField.textContentType = newValue
        }
    }
    
    @IBInspectable
    public var alignment: NSTextAlignment {
        get {
            return textField.textAlignment
        }
        set {
            textField.textAlignment = newValue
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var placeholder: String? {
        get {
            return textField.placeholder
        }
        set {
            textField.attributedPlaceholder = NSAttributedString(string: newValue ?? "", attributes: [
                .font: textFont ?? UIFont.systemFont(ofSize: 15),
                .foregroundColor: placeholderColor
            ])
            textField.placeholder = newValue
            titleLabel.text = newValue
        }
    }
    
    @IBInspectable
    public var titleFont: UIFont {
        get {
            return titleLabel.font
        }
        set {
            titleLabel.font = newValue
        }
    }
    
    @IBInspectable
    public var textFont: UIFont? {
        get {
            return textField.font
        }
        set {
            textField.font = newValue
        }
    }
    
    @IBInspectable
    public var textColor: UIColor? {
        get {
            return textField.textColor
        }
        set {
            textField.textColor = newValue
        }
    }
    
    @IBInspectable
    public var placeholderColor: UIColor = .white
    
    @IBInspectable
    public var titleInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5) {
        didSet {
            setNeedsLayout()
        }
    }
    
    public override var backgroundColor: UIColor? {
        set {
            titleLabel.backgroundColor = newValue
            super.backgroundColor = newValue
        }
        get {
            return super.backgroundColor
        }
    }
    
    @IBInspectable
    public var fieldTintColor: UIColor! {
        get {
            textField.tintColor
        }
        set {
            textField.tintColor = newValue
        }
    }
    
    let textField = InsettedUITextField()
    private let titleLabel = UILabel()
    private let topTextFieldOffset: CGFloat = 7
    private var titleHGap: CGFloat = 12
    private var isAnimating = false
   
    private enum EditingState {
        case placeholder
        case text
    }
    private var editingState: EditingState {
        let state: EditingState
        if textField.text?.count ?? 0 == 0 {
            state = .placeholder
        } else {
            state = .text
        }
        return state
    }
    private lazy var _editingState: EditingState = self.editingState
    private var titleLabelTransform: CGAffineTransform = .identity {
        didSet {
            titleLabel.transform = titleLabelTransform
        }
    }
    public private(set) lazy var passwordVisibilityButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setTitle("Show", for: .normal)
        button.setTitle("Hide", for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(onVisibilityButtonClick), for: .touchUpInside)
        button.sizeToFit()
        return button
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        addSubview(textField)
        addSubview(titleLabel)
        addSubview(passwordVisibilityButton)
        
        backgroundColor = .white
        titleFont = UIFont.systemFont(ofSize: 12)
        textFont = UIFont.systemFont(ofSize: 17)
        textColor = .black
        placeholderColor = UIColor.black.withAlphaComponent(0.3)
        fieldTintColor = .black
        
        borderColor = UIColor.black.withAlphaComponent(0.3)
        activeBorderColor = .purple
        errorBorderColor = .red
        
        titleColor = .black
        activeTitleColor = .purple
        errorTitleColor = .red
        
        validityState = .normal
        
        passwordVisibilityButton.setTitleColor(activeTitleColor, for: .normal)
        
        titleLabel.backgroundColor = backgroundColor
        titleLabel.textAlignment = .center
        
        textField.borderStyle = .none
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.textAlignment = .left
        textField.textInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        textField.addTarget(self, action: #selector(onEditing), for: .editingChanged)
        textField.addTarget(self, action: #selector(onBeginEditing), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(onEndEditing), for: .editingDidEnd)
        applyState(_editingState)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        textField.frame = bounds.inset(by: UIEdgeInsets(top: topTextFieldOffset, left: 0, bottom: 0, right: 0))
        textField.textInsets.right = passwordVisibilityButton.isHidden ? 0 : passwordVisibilityButton.bounds.width + 8
        
        passwordVisibilityButton.center = CGPoint(x: bounds.width - (passwordVisibilityButton.bounds.width / 2) - titleHGap, y: bounds.midY + topTextFieldOffset / 2)
        
        guard !isAnimating else {
            return
        }
        titleLabel.transform = .identity
        titleLabel.sizeToFit()
        let labelSize = titleLabel.bounds.inset(by: UIEdgeInsets(top: -titleInsets.top, left: -titleInsets.left, bottom: -titleInsets.bottom, right: -titleInsets.right)).size
        let labelY = textField.frame.origin.y - labelSize.height / 2.0
        switch alignment {
        case .left:
            titleLabel.frame = CGRect(origin: CGPoint(x: titleHGap, y: labelY), size: labelSize)
        case .center:
            titleLabel.frame = CGRect(origin: CGPoint(x: textField.frame.origin.x + textField.frame.size.width / 2.0 - labelSize.width / 2.0, y: labelY), size: labelSize)
        default:
            fatalError("\(self.self): \(alignment) is not supported")
            break
        }
        titleLabel.transform = titleLabelTransform
    }
    
    private func updateTitleVisibility(animated: Bool) {
        let newState = editingState
        if _editingState != newState {
            _editingState = newState
            if animated {
                layer.removeAllAnimations()
                isAnimating = true
                UIView.animate(withDuration: 0.1, animations: {
                    self.applyState(newState)
                }, completion: { _ in
                    self.isAnimating = false
                    self.setNeedsLayout()
                })
            } else {
                applyState(newState)
            }
        }
    }
    
    private func updateButtonVisibility() {
        guard case .secure(withButton: true) = securityState else {
            passwordVisibilityButton.isHidden = true
            return
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.passwordVisibilityButton.isHidden = self.textField.text?.isEmpty ?? true
        })
    }

    private func applyState(_ state: EditingState) {
        switch state {
        case .placeholder:
            titleLabel.alpha = 0
            titleLabelTransform = CGAffineTransform(translationX: 0, y: 10)
        case .text:
            titleLabel.alpha = 1
            titleLabelTransform = .identity
        }
    }
    
    // MARK: - UITextField events
    @objc
    private func onBeginEditing() {
        if validityState != .error {
            validityState = .active
        }
    }
    
    @objc
    private func onEndEditing() {
        validityState = .normal
    }
    
    @objc
    private func onEditing() {
        validityState = .active
        updateTitleVisibility(animated: true)
        updateButtonVisibility()
    }
    
    // MARK: - Actions
    @objc
    private func onVisibilityButtonClick(_ sender: UIButton) {
        passwordVisibilityButton.isSelected = !passwordVisibilityButton.isSelected
        textField.isSecureTextEntry = !passwordVisibilityButton.isSelected
    }
    
    // MARK: - Intrinsic size
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 47)
    }
}
