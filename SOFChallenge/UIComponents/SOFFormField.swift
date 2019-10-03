//
//  SOFFormField.swift
//  SOFChallenge
//
//  Created by Arbi on 01/10/2019.
//  Copyright © 2019 org.code.ios.com. All rights reserved.
//

import UIKit


@objc public class InsetTextField: UITextField {
    
    var textInsets: UIEdgeInsets {
        var insets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        if rightView != nil {
            insets.right = rightViewInsets.right + 8
        }
        return insets
    }
    var editInsets: UIEdgeInsets {
        var insets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        if clearButtonMode == .whileEditing {
            insets.right = 0
        }
        if rightView != nil {
            insets.right = rightViewInsets.right + 8
        }
        return insets
    }
    let rightViewInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        let textRect = super.textRect(forBounds: bounds)
        return textRect.inset(by: textInsets)
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        let editingRect = super.editingRect(forBounds: bounds)
        return editingRect.inset(by: editInsets)
    }
    
    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let placeholderRect = super.editingRect(forBounds: bounds)
        return placeholderRect.inset(by: textInsets)
    }
    
    override public func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rightViewRect = super.rightViewRect(forBounds: bounds)
        rightViewRect.origin.x -= rightViewInsets.right
        return rightViewRect
    }
}


@objc public enum TextFieldState: Int {
    case inactive
    case active
    case error
    case disabled
    
    var borderColor: UIColor {
        switch self {
        case .inactive, .disabled:
            return .lightGray
        case .active:
            return .blue
        case .error:
            return .red
        }
    }
    
    var helperTextColor: UIColor {
        switch self {
        case .inactive, .active, .disabled:
            return .darkGray
        case .error:
            return .red
        }
    }
}

@objc protocol FormFieldDelegate: NSObjectProtocol {
    func formDidBeginEditing(_ form: SOFFormField)
    func formDidEndEditing(_ form: SOFFormField)
    func formShouldReturn(_ form: SOFFormField) -> Bool
    func formValueChanged(_ form: SOFFormField)
    func form(_ form: SOFFormField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
}

extension FormFieldDelegate {
    public func formDidBeginEditing(_ form: SOFFormField) {
        form.textFieldState = .active
    }
    
    public func formDidEndEditing(_ form: SOFFormField) {
        form.textFieldState = .inactive
        form.textField.resignFirstResponder()
    }
    
    public func formShouldReturn(_ form: SOFFormField) -> Bool {
        form.textFieldState = .inactive
        form.textField.resignFirstResponder()
        return true
    }
}

@objc class SOFFormField: UIView {
    

    @objc public weak var delegate: FormFieldDelegate?
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    private let hintLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 2
        return label
    }()
    @objc public let textField: InsetTextField = {
        let textField = InsetTextField()
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4
        textField.backgroundColor = .white
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.textColor = .black
        return textField
    }()
    
    @objc public var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    @objc public var textFieldState: TextFieldState = .inactive {
        didSet {
            textField.layer.borderColor = textFieldState.borderColor.cgColor
            hintLabel.textColor = textFieldState.helperTextColor
    
            if textFieldState == .disabled {
                textField.isUserInteractionEnabled = false
            }
        }
    }
    
    @objc public var hintText: String? {
        didSet {
            hintLabel.text = hintText
        }
    }
    
    @objc public var errorText: String?
    
    /// accessoryView has a 16 point trailing inset
    @objc public var accessoryView: UIView? {
        didSet {
            textField.rightView = accessoryView
            textField.rightViewMode = .always
        }
    }
    
    @objc public init(titleText: String?,
                      placeholderText: String?,
                      helperText: String?,
                      errorText: String?,
                      autoFillInputText: String? = nil) {
        self.titleText = titleText
        self.hintText = helperText
        self.errorText = errorText
        
        super.init(frame: .zero)
        
        textField.delegate = self
        textField.placeholder = placeholderText
        textField.text = autoFillInputText
        textField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        titleLabel.text = titleText
        hintLabel.text = helperText
        setupViews()
        setInitalConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
extension SOFFormField {
    func setupViews() {
        backgroundColor = .clear
        setDoneOnKeyboard()
        addSubview(titleLabel)
        addSubview(textField)
        addSubview(hintLabel)
    }
    
    func setInitalConstraints() {
        titleLabel.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        
        textField.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 4)
        textField.autoPinEdge(toSuperviewEdge: .leading)
        textField.autoPinEdge(toSuperviewEdge: .trailing)
        textField.autoSetDimension(.height, toSize: 44)
        
        hintLabel.autoPinEdge(.top, to: .bottom, of: textField, withOffset: 4)
        hintLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0, left: 0, bottom: 6, right: 0), excludingEdge: .top)
    }
}

// MARK: - Text Field Updated
extension SOFFormField {
    @objc func textFieldValueChanged(_ form: SOFFormField) {
        hideErrorMessage()
        textFieldState = .active
        delegate?.formValueChanged(self)
    }
}

// MARK: - UITextFieldDelegate
extension SOFFormField: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldState = .active
        delegate?.formDidBeginEditing(self)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldState = .inactive
        delegate?.formDidEndEditing(self)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return delegate?.formShouldReturn(self) ?? true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return delegate?.form(self, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
}

// MARK: - Show/Hide Error Message
@objc extension SOFFormField {
    /// Text field is set to error state and sets the hintLabel to the errorText
    @objc public func showErrorMessage() {
        textFieldState = .error
        hintLabel.text = errorText
    }
    
    /// Sets the hintLabel to the hintText and the text field is set to inactive, and when the user types again the text field will become active and
    @objc public func hideErrorMessage() {
        textFieldState = .inactive
        hintLabel.text = hintText
    }
}

// MARK: - Keyboard input accessory view.
extension SOFFormField {
    func setDoneOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        doneBarButton.tintColor = .blue
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        textField.inputAccessoryView = keyboardToolbar
    }
    
    @objc func dismissKeyboard() {
        textField.endEditing(true)
    }
}

