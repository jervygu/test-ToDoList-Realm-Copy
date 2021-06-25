//
//  EntryItemViewController.swift
//  ToDoList-Realm
//
//  Created by Jervy Umandap on 6/25/21.
//

import UIKit
import RealmSwift

class EntryItemViewController: UIViewController, UITextFieldDelegate {
    
    private let realm = try! Realm()
    
    public var completionHandler: (() -> Void)?
    
    private let textField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.placeholder = "Enter text here..."
        field.textColor = .label
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .wheels
        picker.calendar = .current
        picker.locale = .current
        picker.datePickerMode = .dateAndTime
        picker.backgroundColor = .secondarySystemBackground
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(textField)
        view.addSubview(datePicker)

        textField.becomeFirstResponder()
        textField.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSave))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        
        datePicker.setDate(Date(), animated: true)
        
    }
    
    @objc private func didTapSave() {
        print("Did tap save")
        if let text = textField.text, !text.isEmpty {
            let date = datePicker.date
            
            realm.beginWrite()
            
            let newItem = ToDoListItem()
            newItem.item = text
            newItem.date = date
            realm.add(newItem)
            
            try! realm.commitWrite()
            
            completionHandler?()
            dismiss(animated: true, completion: nil)
            
        } else {
            print("Add something")
        }
    }
    
    @objc private func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        textField.frame = CGRect(x: 10, y: view.safeAreaInsets.top+10, width: view.width-20, height: 50)
        datePicker.frame = CGRect(x: 10, y: textField.bottom+10, width: view.width-20, height: 200)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    

}
