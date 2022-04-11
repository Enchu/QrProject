//
//  AdminViewController.swift
//  QrProject
//
//  Created by Алексей Германов on 11.04.2022.
//

import UIKit
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

class AdminViewController: UIViewController {

    
    @IBOutlet weak var searchTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleTextField(searchTextField)
  
    }
    
    
    @IBAction func searchTaped(_ sender: Any) {
        
        let db = Firestore.firestore()
        
        
    }
    
    
    
}
