//
//  AdminViewController.swift
//  QrProject
//
//  Created by Алексей Германов on 11.04.2022.
//

import UIKit

class AdminViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleTextField(searchTextField)
    }
    


}
