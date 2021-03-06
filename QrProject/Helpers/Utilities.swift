//
//  Utilities.swift
//  QrProject
//
//  Created by Алексей Германов on 08.04.2022.
//

import Foundation
import UIKit
import SwiftUI


class Utilities{
    
    static func styleTextField(_ textField:UITextField){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x:0,y: textField.frame.height - 2, width: textField.frame.width - 24,height: 2)
        //bottomLine.backgroundColor = UIColor.init(red:48/255,green: 173/255,blue: 88/255,alpha: 1).cgColor
        bottomLine.backgroundColor = UIColor.init(red:253/255,green: 23/255,blue: 101/255,alpha: 1).cgColor
        textField.borderStyle = .none
        textField.leftViewMode = .always
        textField.clearButtonMode = .always
        textField.returnKeyType = .done
        textField.font = UIFont(name: "Apple SD Gothic Neo", size: 20)
        textField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        textField.tintColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.addSublayer(bottomLine)
    }
    
    
    static func styleLabel(_ label:UILabel){
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 16)
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        //#colorLiteral (
        label.textColor = #colorLiteral(red: 0.9564198852, green: 0.9451850057, blue: 0.8892086744, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    static func styleColorTextField(_ textField:UITextField){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x:0, y: textField.frame.height - 2, width:textField.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 0/255, green: 100/255, blue: 0/255, alpha: 1).cgColor
        textField.layer.addSublayer(bottomLine)
    }
    
    static func styleColorTextFieldRed(_ textField:UITextField){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x:0, y: textField.frame.height - 2, width:textField.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.init(red:253/255,green: 23/255,blue: 101/255,alpha: 1).cgColor
        textField.layer.addSublayer(bottomLine)
    }
    
    static func styleFiledButton(_ button:UIButton){
        button.backgroundColor = UIColor.init(red: 51/255, green: 122/255, blue: 183/255, alpha:1)
        button.backgroundColor = UIColor.init(red: 0/255, green: 37/255, blue: 89/255, alpha:1)
        button.layer.cornerRadius = 25.0
        button.titleLabel?.font = UIFont(name: "Avenir Book", size: 17)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton){
        button.layer.borderWidth=2
        button.layer.borderColor=UIColor.blue.cgColor
        button.layer.cornerRadius=25
        button.tintColor=UIColor.blue
    }
    
     static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func isCurrentSize(_ textField:String)->Bool{
        let textFieldTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])[A-Za-z]{3,}")
        return textFieldTest.evaluate(with: textField)
    }
    
    static func isPasswordValid(_ password:String)->Bool{
        //let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,}")
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^{6,}")
        return passwordTest.evaluate(with: password)
    }
}

