//
//  DataPickerTextField.swift
//  QrProject
//
//  Created by Алексей Германов on 29.04.2022.
//

import Foundation
import SwiftUI

struct DatePickerTextField: UIViewRepresentable{
    
    private let textField = UITextField()
    private let datePicker = UIDatePicker()
    private let helper = Helper()
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "ru_Ru")
        return dateFormatter
    }()
    
    
    public var placeholder: String
    @Binding public var date: Date?
    
    
    func makeUIView(context: Context) -> UITextField{
        self.datePicker.datePickerMode = .dateAndTime
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.addTarget(self.helper, action: #selector(self.helper.dateValueChanged), for: .valueChanged)
        self.textField.placeholder = self.placeholder
        self.textField.inputView = self.datePicker
        //var currentDateTime = dateFormatter.string(from: date!)
        
        //Accessory View
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Закрыть",
                                         style: .plain,
                                         target: self.helper,
                                         action: #selector(self.helper.doneButtonAction))
        
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        self.textField.inputAccessoryView = toolbar
        
        self.helper.dateChanged = {
            self.date = self.datePicker.date
        }
        
        self.helper.doneButtonTapped = {
            if self.date == nil{
                self.date = self.datePicker.date
            }
            self.textField.resignFirstResponder()
        }
        
        return self.textField
    }
    func updateUIView(_ uiView: UITextField, context: Context) {
        if let selectedDate = self.date{
            uiView.text = self.dateFormatter.string(from: selectedDate)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Helper {
        public var dateChanged: (() -> Void)?
        public var doneButtonTapped: (() -> Void)?
        @objc func dateValueChanged(){
            self.dateChanged?()
        }
        @objc func doneButtonAction(){
            self.doneButtonTapped?()
        }
    }
    
    class Coordinator{
        
    }
    
}
 
