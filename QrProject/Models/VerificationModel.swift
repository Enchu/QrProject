//
//  VerificationModel.swift
//  QrProject
//
//  Created by Алексей Германов on 20.04.2022.
//

import Foundation

class VerificationModel{
    private let mailsArray = ["@gmail.com","@yandex.ru","@mail.ru"]
    public var nameMail = String()
    public var filtredMailArray = [String]()
    
    private func filtringMail(text: String){
        var domainMail = String()
        filtredMailArray = []
        
        guard let firstIndex = text.firstIndex(of: "@") else{ return }
        let endIndex = text.index(before: text.endIndex)
        let range = text[firstIndex...endIndex]
        domainMail = String(range)
        
        mailsArray.forEach { mail in
            if mail.contains(domainMail){
                if !filtredMailArray.contains(mail){
                    filtredMailArray.append(mail)
                }
            }
        }
    }
    public func getFiltredMail(text:String){
        filtringMail(text: text)
    }
}
