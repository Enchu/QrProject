//
//  StatusLabel.swift
//  QrProject
//
//  Created by Алексей Германов on 20.04.2022.
//

import Foundation
import UIKit

class StatusLabel:UILabel{
    override init(frame:CGRect){
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        text = "Check your mail"
        textColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
        font = UIFont(name: "Apple SD Gothic Neo", size: 16)
        adjustsFontSizeToFitWidth = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}
